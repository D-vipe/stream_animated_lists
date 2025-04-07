import 'package:flutter/material.dart';
import 'package:stream_animated_lists/src/common/entities/list_model.dart';


class AnimatedListModel<E> extends ListModel<E> {
  AnimatedListModel(
      {required this.globalKey, Iterable<E>? initialItems, required super.removedItemBuilder})
      : super(listKey: globalKey);

  final GlobalKey<AnimatedListState> globalKey;

  AnimatedListState get _animatedList => globalKey.currentState!;

  @override
  void insert(int index, E item, Duration animationDuration) {
    items.insert(index, item);
    _animatedList.insertItem(index, duration: animationDuration);
  }

  void insertAll(int index, Iterable<E> newItems, Duration animationDuration) {
    items.insertAll(index, newItems);
    _animatedList.insertAllItems(index, newItems.length, duration: animationDuration);
  }

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

  int get length => items.length;

  E operator [](int index) => items[index];

  int indexOf(E item) => items.indexOf(item);
}
