import 'package:flutter/material.dart';
import 'package:stream_animated_lists/stream_animated_lists.dart';

/// Wrapper widget used to pass necessary widgets of your own
/// to the animated list widget
///
/// [child] - your widget that should be animated and shown in the list
///
/// [animationType] - you can specify this if you want to change animation type
/// when this parameter has already been defined for [AnimatedList] or [SliverAnimatedList]
class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool isInserting;
  final ListItemAnimationType? animationType;


  const AnimatedListItem({
    super.key,
    required this.child,
    required this.isLoading,
    this.isInserting = false,
    this.animationType,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
