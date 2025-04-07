import 'package:flutter/material.dart';
import 'package:stream_animated_lists/src/common/typedefs/tl_animated_list_type_defs.dart';

abstract class ListModel<E> {
  final GlobalKey<AnimatedListState>? listKey;
  final GlobalKey<SliverAnimatedListState>? sliverListKey;
  final GlobalKey<AnimatedGridState>? gridKey;
  final GlobalKey<SliverAnimatedGridState>? sliverGridKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> items;

  ListModel(
      {this.listKey,
      this.gridKey,
      this.sliverListKey,
      this.sliverGridKey,
      required this.removedItemBuilder,
      Iterable<E>? initialItems})
      : items = List<E>.from(initialItems ?? <E>[]);

  void insert(int index, E item, Duration animationDuration);
  void insertAll(int index, Iterable<E> newItems, Duration animationDuration);

  E removeAt(int index, Duration animationDuration);

  int get length => items.length;

  E operator [](int index) => items[index];

  int indexOf(E item) => items.indexOf(item);
}
