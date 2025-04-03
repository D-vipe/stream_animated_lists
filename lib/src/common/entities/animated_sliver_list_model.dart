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

import '../typedefs/tl_animated_list_type_defs.dart';

class SliverListModel<E> {
  SliverListModel({required this.listKey, required this.removedItemBuilder, Iterable<E>? initialItems})
      : items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<SliverAnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> items;

  SliverAnimatedListState get _animatedList => listKey.currentState!;

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
