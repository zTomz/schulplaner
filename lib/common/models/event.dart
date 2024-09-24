import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:schulplaner/common/extensions/duration_extension.dart';

/// An event in the calendar
abstract class Event {
  /// The name of the event
  final String name;

  /// Optional. The description of the event
  final String? description;

  /// When the event is due
  final DateTime date;

  /// The type of the event
  final EventTypes type;

  /// A unique identifier
  final String uuid;

  Event({
    required this.name,
    this.description,
    required this.date,
    required this.type,
    required this.uuid,
  });
}

// TODO: Add homework and other classes here. These should be subclasses of [Event]

/// A homework event
class HomeworkEvent extends Event {
  /// The subject of the homework. E. g. Math, English etc.
  final String subjectUuid;

  /// Whether the homework is done
  final bool isDone;

  HomeworkEvent({
    required super.name,
    required super.description,
    required super.date,
    required this.subjectUuid,
    required this.isDone,
    required super.uuid,
  }) : super(type: EventTypes.homework);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': Timestamp.fromDate(date),
      'subjectUuid': subjectUuid,
      'description': description,
      'isDone': isDone,
      'uuid': uuid,
    };
  }

  factory HomeworkEvent.fromMap(Map<String, dynamic> map) {
    return HomeworkEvent(
      name: map['name'],
      date: (map['date'] as Timestamp).toDate(),
      subjectUuid: map['subjectUuid'],
      description: map['description'],
      isDone: map['isDone'],
      uuid: map['uuid'],
    );
  }

  HomeworkEvent copyWith({
    String? name,
    String? description,
    DateTime? date,
    String? subjectUuid,
    bool? isDone,
    String? uuid,
  }) {
    return HomeworkEvent(
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      subjectUuid: subjectUuid ?? this.subjectUuid,
      isDone: isDone ?? this.isDone,
      uuid: uuid ?? this.uuid,
    );
  }
}

/// A test event.
class TestEvent extends Event {
  /// The dates, when the pratice for the test is due
  final List<EventDate> praticeDates;

  /// The subject of the test. E. g. Math, English etc.
  final String subjectUuid;

  TestEvent({
    required super.name,
    required super.description,
    required super.uuid,
    required super.date,
    required this.praticeDates,
    required this.subjectUuid,
  }) : super(type: EventTypes.test);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'praticeDates': praticeDates.map((x) => x.toMap()).toList(),
      'subjectUuid': subjectUuid,
      'uuid': uuid,
    };
  }

  factory TestEvent.fromMap(Map<String, dynamic> map) {
    return TestEvent(
      name: map['name'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      praticeDates: List<EventDate>.from(
          map['praticeDates']?.map((x) => EventDate.fromMap(x))),
      subjectUuid: map['subjectUuid'] ?? '',
      uuid: map['uuid'],
    );
  }
}

class FixedEvent extends Event {
  /// Optional. Where the event takes place
  final String? place;

  /// The color of the event
  final Color color;

  FixedEvent({
    required super.name,
    required super.description,
    required super.date,
    required this.color,
    required super.uuid,
    this.place,
  }) : super(type: EventTypes.fixed);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'place': place,
      'color': color.value,
      'date': Timestamp.fromDate(date),
      'uuid': uuid,
    };
  }

  factory FixedEvent.fromMap(Map<String, dynamic> map) {
    return FixedEvent(
      name: map['name'],
      description: map['description'],
      place: map['place'],
      color: Color(map['color']),
      date: (map['date'] as Timestamp).toDate(),
      uuid: map['uuid'],
    );
  }
}

class RepeatingEvent extends Event {
  /// The type of repeating event. E. g. daily, weekly, monthly, yearly
  final RepeatingEventType repeatingEventType;

  /// The color of the event
  final Color color;

  RepeatingEvent({
    required super.name,
    required super.description,
    required super.date,
    required this.repeatingEventType,
    required this.color,
    required super.uuid,
  }) : super(type: EventTypes.repeating);
}

/// A date with a duration
class EventDate {
  /// The date of the event
  final DateTime date;

  /// How long the event lasts
  final Duration duration;

  EventDate({
    required this.date,
    required this.duration,
  });

  String get formattedDate =>
      "${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")} Uhr, ${date.day}.${date.month}.${date.year}";

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'duration': duration.toMap(),
    };
  }

  factory EventDate.fromMap(Map<String, dynamic> map) {
    return EventDate(
      date: (map['date'] as Timestamp).toDate(),
      duration: durationFromMap(map['duration']),
    );
  }
}

/// The type of repeating event. E. g. daily, weekly, monthly, yearly
enum RepeatingEventType {
  daily,
  weekly,
  monthly,
  yearly;
}

enum EventTypes {
  homework,
  test,
  fixed,
  repeating,
}
