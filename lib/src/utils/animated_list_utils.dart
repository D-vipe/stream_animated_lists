import 'package:flutter/material.dart';
import 'package:stream_animated_lists/src/common/entities/animated_list_model.dart';
import 'package:stream_animated_lists/src/common/entities/animated_sliver_list_model.dart';
import 'package:stream_animated_lists/src/widgets/common/animated_item_switcher_widget.dart';
import 'package:stream_animated_lists/src/widgets/common/animated_list_item_widget.dart';
import 'package:stream_animated_lists/src/widgets/common/animated_separator_widget.dart';
import 'package:stream_animated_lists/stream_animated_lists.dart';

class AnimatedListUtils {
  late ListModel<AnimatedListItem>? list;
  late SliverListModel<AnimatedListItem>? sliverList;
  final GlobalKey<SliverAnimatedListState>? _sliverListKey;
  final GlobalKey<AnimatedListState>? _listKey;
  final List<AnimatedListItem> items;
  final Duration animationDuration;
  final Duration removeAnimationDuration;
  final Widget? shimmerWidget;
  final Widget? separatorWidget;
  final ListItemAnimationType animationType;
  final ListItemAnimationType removeAnimationType;
  final VoidCallback callSetState;

  AnimatedListUtils(
    listKey,
    sliverListKey, {
    required this.items,
    required this.animationDuration,
    required this.removeAnimationDuration,
    required this.animationType,
    required this.shimmerWidget,
    this.separatorWidget,
    required this.removeAnimationType,
    required this.callSetState,
  })  : _listKey = listKey,
        _sliverListKey = sliverListKey {
    _initialize();
  }

  bool get _isSliver => _sliverListKey != null;

  int get _getListLength => _isSliver ? sliverList!.length : list!.length;

  AnimatedListItem _getItemFromList(int index) => _isSliver ? sliverList![index] : list![index];

  void _initialize() {
    assert(_listKey != null && _sliverListKey == null || _listKey == null && _sliverListKey != null,
        'You must provide either [listKey] or [sliverListKey]');
    list = _listKey != null
        ? ListModel<AnimatedListItem>(
            listKey: _listKey,
            initialItems: items,
            removedItemBuilder: _buildRemovedItem,
          )
        : null;
    sliverList = _sliverListKey != null
        ? SliverListModel<AnimatedListItem>(
            listKey: _sliverListKey,
            removedItemBuilder: _buildRemovedItem,
          )
        : null;
  }

  void eventListener(AnimatedListEvent event) {
    if (event is BatchUpdateItemsEvent) {
      final List<AnimatedListItem> newItems = event.items;
      final int newCount = newItems.length;
      final int oldCount = _isSliver ? sliverList!.length : list!.length;

      if (newCount >= oldCount) {
        final List<AnimatedListItem> itemsToUpdate = newItems.getRange(0, oldCount).toList();

        if (_isSliver) {
          sliverList = SliverListModel<AnimatedListItem>(
            listKey: _sliverListKey!,
            initialItems: itemsToUpdate,
            removedItemBuilder: sliverList!.removedItemBuilder,
          );
        } else {
          list = ListModel<AnimatedListItem>(
            listKey: _listKey!,
            initialItems: itemsToUpdate,
            removedItemBuilder: list!.removedItemBuilder,
          );
        }

        final Iterable<AnimatedListItem> itemsToInsert =
            newItems.getRange(oldCount, newItems.length);

        if (itemsToInsert.isNotEmpty) {
          _insertAll(itemsToInsert);
        } else {
          // If the new count is equal to the old count, we don't need to insert
          // any new items. We just need to update the existing items.
          callSetState();
        }

        return;
      }

      if (newCount < oldCount) {
        final List<AnimatedListItem> oldItems = _isSliver ? sliverList!.items : list!.items;

        final List<AnimatedListItem> itemsToDelete =
            oldItems.getRange(newCount, oldItems.length).toList();

        for (final item in itemsToDelete) {
          _remove(item);
        }

        if (_isSliver) {
          sliverList = SliverListModel<AnimatedListItem>(
            listKey: _sliverListKey!,
            initialItems: newItems,
            removedItemBuilder: sliverList!.removedItemBuilder,
          );
        } else {
          list = ListModel<AnimatedListItem>(
            listKey: _listKey!,
            initialItems: newItems,
            removedItemBuilder: list!.removedItemBuilder,
          );
        }

        return;
      }
    }

    if (event is RemoveItemEvent) {
      final int index = event.index;

      final int itemsCount = _isSliver ? sliverList!.length : list!.length;

      if (index >= 0 && index < itemsCount) {
        _remove(_getItemFromList(index));
      }
    }

    if (event is LoadingMoreEvent) {
      final AnimatedListItem item = event.item;
      _insert(item);
    }

    if (event is AddItemEvent) {
      final AnimatedListItem item = event.item;
      _insert(item, index: event.index);
    }
  }

  // Insert the "next item" into the list model.
  void _insert(AnimatedListItem item, {int? index}) {
    _isSliver
        ? sliverList!.insert(index ?? _getListLength, item, animationDuration)
        : list!.insert(index ?? _getListLength, item, animationDuration);
  }

  void _insertAll(Iterable<AnimatedListItem> items, {int? index}) {
    _isSliver
        ? sliverList!.insertAll(index ?? _getListLength, items, animationDuration)
        : list!.insertAll(index ?? _getListLength, items, animationDuration);
  }

  // Remove the selected item from the list model.
  void _remove(AnimatedListItem item) {
    _isSliver
        ? sliverList!.removeAt(sliverList!.indexOf(item), removeAnimationDuration)
        : list!.removeAt(list!.indexOf(item), removeAnimationDuration);
  }

  // Used to build list items that haven't been removed.
  Widget buildItem(BuildContext context, int index, Animation<double> animation) =>
      shimmerWidget != null
          ? AnimatedListItemWidget(
              animation: animation,
              animationType:
                  (_isSliver ? sliverList![index].animationType : list![index].animationType) ??
                      animationType,
              index: index,
              isInserting: _isSliver ? sliverList![index].isInserting : list![index].isInserting,
              child: AnimatedItemSwitcher(
                shimmer: shimmerWidget!,
                showShimmer: _isSliver ? sliverList![index].isLoading : list![index].isLoading,
                child: _isSliver ? sliverList![index] : list![index],
              ),
            )
          : AnimatedListItemWidget(
              animation: animation,
              index: index,
              animationType:
                  (_isSliver ? sliverList![index].animationType : list![index].animationType) ??
                      animationType,
              isInserting: _isSliver ? sliverList![index].isInserting : list![index].isInserting,
              child: _isSliver ? sliverList![index] : list![index],
            );

  /// The builder function used to build items that have been removed.
  ///
  /// Used to build an item after it has been removed from the list. This method
  /// is needed because a removed item remains visible until its animation has
  /// completed (even though it's gone as far this ListModel is concerned). The
  /// widget will be used by the [AnimatedListState.removeItem] method's
  /// [AnimatedRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(
          Widget item, BuildContext context, Animation<double> animation, int index) =>
      AnimatedListItemWidget(
        animation: animation,
        index: index,
        animationType: removeAnimationType,
        isRemoving: true,
        child: item,
      );

  // Used to build separators for items that haven't been removed.
  Widget buildSeparator(BuildContext context, int index, Animation<double> animation) =>
      AnimatedSeparatorWidget(
        animation: animation,
        separator: separatorWidget ??
            Divider(
              height: 2.0,
            ),
      );

  /// The builder function used to build a separator for an item that has been removed.
  ///
  /// Used to build a separator after the corresponding item has been removed from the list.
  /// This method is needed because the separator of a removed item remains visible until its animation has completed.
  /// The widget will be passed to [AnimatedList.separated]
  /// via the [AnimatedList.removedSeparatorBuilder] parameter and used
  /// in the [AnimatedListState.removeItem] method.
  ///
  /// The item parameter is null, because the corresponding item will
  /// have been removed from the list model by the time this builder is called.
  Widget buildRemovedSeparator(BuildContext context, int index, Animation<double> animation) =>
      AnimatedSeparatorWidget(
        animation: animation,
        isRemoving: true,
        separator: separatorWidget ??
            Divider(
              height: 2.0,
            ),
      );
}
