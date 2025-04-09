import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_animated_lists/src/utils/animated_list_utils.dart';
import 'package:stream_animated_lists/stream_animated_lists.dart';

class AnimatedListWrapper extends StatefulWidget {
  final Stream<AnimatedListEvent> eventStream;
  final List<AnimatedListItem> items;
  final Widget? shimmerWidget;
  final ListItemAnimationType animationType;
  final ListItemAnimationType removeAnimationType;
  final Duration animationDuration;
  final Duration removeAnimationDuration;
  final VoidCallback initLoadingState;
  final bool isSeparated;
  final Widget separatorWidget;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final ScrollDirection? scrollDirection;
  final bool? primaryScroll;
  final bool reverse;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Clip clipBehavior;

  const AnimatedListWrapper({
    super.key,
    required this.eventStream,
    required this.items,
    required this.initLoadingState,
    this.shimmerWidget,
    this.animationType = ListItemAnimationType.base,
    this.removeAnimationType = ListItemAnimationType.ltr,
    this.animationDuration = const Duration(milliseconds: 400),
    this.removeAnimationDuration = const Duration(milliseconds: 800),
    this.isSeparated = false,
    this.separatorWidget = const Divider(
      height: 2.0,
    ),
    this.scrollController,
    this.padding,
    this.scrollDirection,
    this.primaryScroll,
    this.reverse = false,
    this.physics,
    this.shrinkWrap = false,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  State<AnimatedListWrapper> createState() => _AnimatedListWrapperState();
}

class _AnimatedListWrapperState extends State<AnimatedListWrapper> {
  late final AnimatedListUtils listUtils;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late StreamSubscription<AnimatedListEvent> _eventSubscription;

  @override
  void initState() {
    super.initState();

    listUtils = AnimatedListUtils(
      _listKey,
      null,
      animationDuration: widget.animationDuration,
      removeAnimationDuration: widget.removeAnimationDuration,
      animationType: widget.animationType,
      shimmerWidget: widget.shimmerWidget,
      separatorWidget: widget.separatorWidget,
      removeAnimationType: widget.removeAnimationType,
      items: widget.items,
      callSetState: () => setState(
        () {},
      ),
    );

    _eventSubscription = widget.eventStream.listen(listUtils.eventListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.initLoadingState());
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isSeparated
        ? AnimatedList.separated(
            key: _listKey,
            initialItemCount: listUtils.list!.length,
            itemBuilder: listUtils.buildItem,
            separatorBuilder: listUtils.buildSeparator,
            removedSeparatorBuilder: listUtils.buildRemovedSeparator,
            physics: widget.physics,
            controller: widget.scrollController,
            padding: widget.padding,
            primary: widget.primaryScroll,
            reverse: widget.reverse,
            shrinkWrap: widget.shrinkWrap,
            clipBehavior: widget.clipBehavior,
          )
        : AnimatedList(
            key: _listKey,
            initialItemCount: listUtils.list!.length,
            itemBuilder: listUtils.buildItem,
            physics: widget.physics,
            controller: widget.scrollController,
            padding: widget.padding,
            primary: widget.primaryScroll,
            reverse: widget.reverse,
            shrinkWrap: widget.shrinkWrap,
            clipBehavior: widget.clipBehavior,
          );
  }
}
