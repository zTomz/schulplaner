import 'package:flutter/material.dart';
import 'package:schulplaner/common/functions/first_where_or_null.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';

Color getColorForEvent(Event event, List<Subject> subjects) {
  switch (event.type) {
    case EventTypes.homework:
      return firstWhereOrNull(
                  subjects,
                  (subject) =>
                      subject.uuid == (event as HomeworkEvent).subjectUuid)
              ?.color ??
          Colors.blue;
    case EventTypes.test:
      return firstWhereOrNull(subjects,
                  (subject) => subject.uuid == (event as TestEvent).subjectUuid)
              ?.color ??
          Colors.blue;
    case EventTypes.fixed:
      return (event as FixedEvent).color;
    case EventTypes.repeating:
      return (event as RepeatingEvent).color;
  }
}
