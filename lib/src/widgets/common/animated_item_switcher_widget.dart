import 'package:flutter/material.dart';

class AnimatedItemSwitcher extends StatelessWidget {
  final Widget child;
  final Widget shimmer;
  final Duration animationDuration;
  final bool showShimmer;

  const AnimatedItemSwitcher({
    super.key,
    required this.child,
    required this.shimmer,
    this.animationDuration = const Duration(milliseconds: 400),
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration,
      child: showShimmer ? shimmer : child,
    );
  }
}
