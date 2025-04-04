import 'package:flutter/material.dart';

class AnimatedSeparatorWidget extends StatelessWidget {
  const AnimatedSeparatorWidget({
    super.key,
    required this.animation,
    this.isRemoving = false,
    required this.separator,
  });

  final Animation<double> animation;
  final bool isRemoving;
  final Widget separator;

  @override
  Widget build(BuildContext context) {
    return isRemoving
        ? SizeTransition(
            sizeFactor: animation,
            child: separator,
          )
        : FadeTransition(
            opacity: Tween<double>(
              begin: 0.0, // Slide in from the bottom
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
              ),
            ),
            child: separator,
          );
  }
}
