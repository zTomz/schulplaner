import 'package:flutter/material.dart';

import 'package:schulplaner/shared/models/time.dart';

typedef HobbiesData = List<Hobby>;

extension HobbiesDataExtension on HobbiesData {
  Map<String, dynamic> get formattedMap => {
        "hobbies": map(
              (hobby) => hobby.toMap(),
            )
            .toList(),
      };
}

class Hobby {
  /// The name of the hobby
  final String name;

  /// The description of the hobby
  final String? description;

  /// The color of the hobby
  final Color color;

  /// If the dates of the hobby are moveable. E. g. if the user goes to the gym,
  /// the data can be moved. But if the user plays handball the date is strict
  final bool moveable;

  /// The days of the hobby. Containing a time span and a day
  final List<TimeInDay> days;

  /// The unique id of the hobby
  final String uuid;

  const Hobby({
    required this.name,
    this.description,
    required this.color,
    required this.moveable,
    required this.days,
    required this.uuid,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'color': color.value,
      'moveable': moveable,
      'days': days.map((x) => x.toMap()).toList(),
      'uuid': uuid,
    };
  }

  factory Hobby.fromMap(Map<String, dynamic> map) {
    return Hobby(
      name: map['name'] ?? '',
      description: map['description'],
      color: Color(map['color']),
      moveable: map['moveable'] ?? false,
      days: List<TimeInDay>.from(map['days']?.map((x) => TimeInDay.fromMap(x))),
      uuid: map['uuid'] ?? '',
    );
  }
}
