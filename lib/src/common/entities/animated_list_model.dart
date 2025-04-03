import 'package:flutter/material.dart';
import 'package:stream_animated_lists/src/common/typedefs/tl_animated_list_type_defs.dart';

class ListModel<E> {
  ListModel({required this.listKey, required this.removedItemBuilder, Iterable<E>? initialItems})
      : items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> items;

  AnimatedListState get _animatedList => listKey.currentState!;

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
