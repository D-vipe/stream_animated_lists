import 'package:flutter/material.dart';

typedef RemovedItemBuilder<E> = Widget Function(
  E item,
  BuildContext context,
  Animation<double> animation,
  int index,
);
