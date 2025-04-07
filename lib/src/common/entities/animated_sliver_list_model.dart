// Keeps a Dart [List] in sync with an [AnimatedList].
//
// The [insert] and [removeAt] methods apply to both the internal list and
// the animated list that belongs to [listKey].
//
// This class only exposes as much of the Dart List API as is needed by the
// sample app. More list methods are easily added, however methods that
// mutate the list must make the same changes to the animated list in terms
// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
import 'package:flutter/material.dart';
import 'package:stream_animated_lists/src/common/entities/list_model.dart';

class SliverListModel<E> extends ListModel<E> {
  SliverListModel(
      {required this.globalKey, Iterable<E>? initialItems, required super.removedItemBuilder})
      : super(sliverListKey: globalKey);

  final GlobalKey<SliverAnimatedListState> globalKey;

  SliverAnimatedListState get _animatedList => globalKey.currentState!;

  @override
  void insert(int index, E item, Duration animationDuration) {
    items.insert(index, item);
    _animatedList.insertItem(index, duration: animationDuration);
  }

  @override
  void insertAll(int index, Iterable<E> newItems, Duration animationDuration) {
    items.insertAll(index, newItems);
    _animatedList.insertAllItems(index, newItems.length, duration: animationDuration);
  }

  @override
  E removeAt(int index, Duration animationDuration) {
    final E removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (context, animation) => removedItemBuilder(removedItem, context, animation, index),
        duration: animationDuration,
      );
    }
    return removedItem;
  }

}
