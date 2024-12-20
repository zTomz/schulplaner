import 'package:flutter/material.dart';

const double kDefaultOpacity = 0.4;

const double kInfoTextWidth = 500;
const double kInfoImageSize = 100;

abstract class Spacing {
  static const double extraSmall = 4;
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
  static const double extraLarge = 36;
}

abstract class Radii {
  static const Radius extraSmall = Radius.circular(6);
  static const Radius small = Radius.circular(12);
  static const Radius medium = Radius.circular(26);
  static const Radius large = Radius.circular(50);
}

abstract class AnimationDurations {
  static const Duration normal = Duration(milliseconds: 200);
}
