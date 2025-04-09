import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_animated_lists/src/utils/animated_list_utils.dart';
import 'package:stream_animated_lists/stream_animated_lists.dart';

class SliverAnimatedListWrapper extends StatefulWidget {
  final Stream<AnimatedListEvent> eventStream;
  final List<AnimatedListItem> items;
  final Widget? shimmerWidget;
  final ListItemAnimationType animationType;
  final ListItemAnimationType removeAnimationType;
  final Duration animationDuration;
  final Duration removeAnimationDuration;
  final VoidCallback initLoadingState;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final ScrollDirection? scrollDirection;
  final bool? primaryScroll;
  final bool reverse;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Clip clipBehavior;

  const SliverAnimatedListWrapper({
    super.key,
    required this.eventStream,
    required this.items,
    required this.initLoadingState,
    this.shimmerWidget,
    this.animationType = ListItemAnimationType.base,
    this.removeAnimationType = ListItemAnimationType.ltr,
    this.animationDuration = const Duration(milliseconds: 400),
    this.removeAnimationDuration = const Duration(milliseconds: 800),
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
  State<SliverAnimatedListWrapper> createState() => _SliverAnimatedListWrapperState();
}

class _SliverAnimatedListWrapperState extends State<SliverAnimatedListWrapper> {
  late final AnimatedListUtils listUtils;
  final GlobalKey<SliverAnimatedListState> _sliverListKey =
      GlobalKey<SliverAnimatedListState>(debugLabel: 'SliverGlobalKey');
  late StreamSubscription<AnimatedListEvent> _eventSubscription;

  @override
  void initState() {
    super.initState();

    listUtils = AnimatedListUtils(
      null,
      _sliverListKey,
      animationDuration: widget.animationDuration,
      removeAnimationDuration: widget.removeAnimationDuration,
      animationType: widget.animationType,
      shimmerWidget: widget.shimmerWidget,
      removeAnimationType: widget.removeAnimationType,
      items: widget.items,
      callSetState: () => setState(() {}),
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
    return SliverAnimatedList(
      key: _sliverListKey,
      initialItemCount: listUtils.sliverList!.length,
      itemBuilder: listUtils.buildItem,
    );
  }
}
