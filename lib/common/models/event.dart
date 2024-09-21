import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/extensions/duration_extension.dart';

/// An event in the calendar
abstract class Event {
  /// The name of the event
  final String name;

  /// Optional. The description of the event
  final String? description;

  /// The type of the event
  final EventTypes type;

  /// A unique identifier
  final String uuid;

  Event({
    required this.name,
    this.description,
    required this.uuid,
    required this.type,
  });
}

// TODO: Add homework and other classes here. These should be subclasses of [Event]

/// A homework event
class HomeworkEvent extends Event {
  /// The date, when the homework event is due
  final EventDate date;

  /// The subject of the homework. E. g. Math, English etc.
  final String subjectUuid;

  HomeworkEvent({
    required super.name,
    required super.description,
    required super.uuid,
    required this.date,
    required this.subjectUuid,
  }) : super(type: EventTypes.homework);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date.toMap(),
      'subjectUuid': subjectUuid,
      'description': description,
      'uuid': uuid,
    };
  }

  factory HomeworkEvent.fromMap(Map<String, dynamic> map) {
    return HomeworkEvent(
      name: map['name'],
      date: EventDate.fromMap(map['date']),
      subjectUuid: map['subjectUuid'],
      description: map['description'],
      uuid: map['uuid'],
    );
  }
}

/// A test event.
class TestEvent extends Event {
  /// When the test takes place
  final DateTime deadline;

  /// The dates, when the pratice for the test is due
  final List<EventDate> praticeDates;

  /// The subject of the test. E. g. Math, English etc.
  final String subjectUuid;

  TestEvent({
    required super.name,
    required super.description,
    required super.uuid,
    required this.deadline,
    required this.praticeDates,
    required this.subjectUuid,
  }) : super(type: EventTypes.test);
}

class FixedEvent extends Event {
  /// When the event is due
  final EventDate date;

  /// Optional. Where the event takes place
  final String? place;

  /// The color of the event
  final Color color;

  FixedEvent({
    required super.name,
    required super.description,
    required this.date,
    required this.color,
    required super.uuid,
    this.place,
  }) : super(type: EventTypes.fixed);
}

class RepeatingEvent extends Event {
  /// When the first event is due
  final EventDate date;

  /// The type of repeating event. E. g. daily, weekly, monthly, yearly
  final RepeatingEventType repeatingEventType;

  /// The color of the event
  final Color color;

  RepeatingEvent({
    required super.name,
    required super.description,
    required this.date,
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
