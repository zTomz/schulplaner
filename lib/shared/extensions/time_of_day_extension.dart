import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  operator >(TimeOfDay other) {
    return calculateMinutes() > other.calculateMinutes();
  }

  operator <(TimeOfDay other) {
    return calculateMinutes() < other.calculateMinutes();
  }

  int calculateMinutes() {
    return hour * 60 + minute;
  }

  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minute': minute,
    };
  }
}

TimeOfDay timeOfDayFromMap(Map<String, dynamic> map) {
  return TimeOfDay(
    hour: int.tryParse(map['hour'].toString()) ?? 0,
    minute: int.tryParse(map['minute'].toString()) ?? 0,
  );
}
