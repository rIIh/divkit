import 'package:flutter/widgets.dart';

extension SizeAxisX on Size {
  double along(Axis axis) {
    switch (axis) {
      case Axis.horizontal:
        return width;

      case Axis.vertical:
        return height;
    }
  }
}
