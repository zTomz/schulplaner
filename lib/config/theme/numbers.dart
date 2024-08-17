import 'package:flutter/material.dart';

abstract class Spacing {
  static const double extraSmall = 4;
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
  static const double extraLarge = 36;
}

abstract class Radii {
  static const Radius medium = Radius.circular(26);
  static const Radius large = Radius.circular(50);
}
