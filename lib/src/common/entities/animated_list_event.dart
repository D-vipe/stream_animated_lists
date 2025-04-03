import 'package:stream_animated_lists/stream_animated_lists.dart';

abstract class AnimatedListEvent {}

class LoadingMoreEvent extends AnimatedListEvent {
  final AnimatedListItem item;

  LoadingMoreEvent(this.item);
}

class RemoveItemEvent extends AnimatedListEvent {
  final int index;

  RemoveItemEvent({required this.index});
}

class AddItemEvent extends AnimatedListEvent {
  final AnimatedListItem item;
  final int? index;

  AddItemEvent(this.item, {this.index});
}

class BatchUpdateItemsEvent extends AnimatedListEvent {
  final List<AnimatedListItem> items;

  BatchUpdateItemsEvent(this.items);
}
