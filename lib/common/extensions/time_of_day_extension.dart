import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  operator >(TimeOfDay other) {
    return _calculateMinutes() > other._calculateMinutes();
  }

  operator <(TimeOfDay other) {
    return _calculateMinutes() < other._calculateMinutes();
  }

  int _calculateMinutes() {
    return hour * 60 + minute;
  }
}
