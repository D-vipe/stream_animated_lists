import 'package:flutter/material.dart';

/// Wrapper widget used to pass necessary widgets of your own
/// to the animated list widget
///
/// [child] - your widget that should be animated and shown in the list
///
/// [isLoading] -
class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  const AnimatedListItem({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
