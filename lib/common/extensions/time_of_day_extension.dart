import 'dart:convert';

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
      'minute': minute,
      'hour': hour,
    };
  }

}

TimeOfDay timeOfDayFromMap(Map<String, dynamic> map) {
  return TimeOfDay(
    minute: int.tryParse(map['minute'].toString()) ?? 0,
    hour: int.tryParse(map['hour'].toString()) ?? 0,
  );
}

TimeOfDay fromJson(String source) => timeOfDayFromMap(json.decode(source));
