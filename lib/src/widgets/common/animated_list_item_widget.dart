import 'package:flutter/material.dart';
import 'package:stream_animated_lists/stream_animated_lists.dart';


class AnimatedListItemWidget extends StatelessWidget {
  const AnimatedListItemWidget({
    super.key,
    required this.index,
    required this.animation,
    required this.child,
    this.animationType = ListItemAnimationType.base,
    this.isRemoving = false,
  });

  final int index;
  final Widget child;
  final Animation<double> animation;
  final ListItemAnimationType animationType;
  final bool isRemoving;

  int _reduceIndex(int count) {
    if (count <= 20) {
      return count;
    } else if (count > 20 && count <= 99) {
      final int lastDigit = int.parse('$count'.split('').last);
      return _reduceIndex(lastDigit);
    } else {
      final List<String> symbolArray = '$count'.split('');
      // Нам понадобится две последние цифры
      final String lastTwoSDigits = '${symbolArray[symbolArray.length - 2]}${symbolArray.last}';

      final int lastTwoDigits = int.parse(lastTwoSDigits);

      return _reduceIndex(lastTwoDigits);
    }
  }

  Offset _getAnimationItemFromAnimationType() => switch (animationType) {
        ListItemAnimationType.vertical => Offset(0.0, 1.0 * (_reduceIndex(index) + 1.75)),
        ListItemAnimationType.rtl => Offset(1.0 * (_reduceIndex(index) + 1.75), 0.0),
        ListItemAnimationType.ltr => Offset(-1.0 * (_reduceIndex(index) + 1.75), 0.0),
        _ => Offset(0.0, 1.0 * (_reduceIndex(index) + 1.75)),
      };

  @override
  Widget build(BuildContext context) {
    switch (animationType) {
      case ListItemAnimationType.base:
        // Use SizeTransition for base animation
        return SizeTransition(
          sizeFactor: animation,
          child: child,
        );

      default:
        return isRemoving
            ? SizeTransition(
                sizeFactor: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: _getAnimationItemFromAnimationType(), // Slide in from the bottom
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.0, 1.0),
                    ),
                  ),
                  child: child,
                ),
              )
            : SlideTransition(
                position: Tween<Offset>(
                  begin: _getAnimationItemFromAnimationType(), // Slide in from the bottom
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.0, 1.0),
                  ),
                ),
                child: child,
              );
    }
  }
}
