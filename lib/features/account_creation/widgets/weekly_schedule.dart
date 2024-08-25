import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/theme/app_colors.dart';
import 'package:schulplaner/config/theme/numbers.dart';

class WeeklySchedule extends StatelessWidget {
  final List<Lesson> lessons;

  const WeeklySchedule({
    super.key,
    required this.lessons,
  });

  static const double _timeColumnWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WeeklyScheduleDaysHeader(timeColumnWidth: _timeColumnWidth),
        Expanded(
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(_timeColumnWidth),
            },
            border: TableBorder.all(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(2),
              width: 2,
            ),
            children: <TableRow>[
              TableRow(
                children: _buildLessonsForTimeSpan(
                  const TimeSpan(
                    from: TimeOfDay(hour: 7, minute: 30),
                    to: TimeOfDay(
                      hour: 9,
                      minute: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Schulstunde zur Tabelle hinzufügen
          },
          icon: const Icon(
            LucideIcons.circle_plus,
            size: 20,
          ),
          label: const Text("Schulstunde hinzufügen"),
        ),
        const SizedBox(height: Spacing.medium),
      ],
    );
  }

  /// Build all lessons for a given time span
  List<Widget> _buildLessonsForTimeSpan(TimeSpan timeSpan) {
    List<Lesson> lessonsToBuild = lessons
        .where(
          (lesson) => lesson.timeSpan == timeSpan,
        )
        .toList();

    List<Widget> widgetsToBuild = [
      TableCell(
        child: Text(
          timeSpan.toFormattedString(),
        ),
      ),
    ];

    for (Weekdays weekday in Weekdays.values) {
      // Get all lessons for the current weekday
      final lessonsForWeekday = lessonsToBuild
          .where(
            (lesson) => lesson.weekday == weekday,
          )
          .toList();

      // Remove the lessons for the current weekday. So the next iteration has less
      // elements to query
      lessonsToBuild.removeWhere(
        (lesson) => lesson.weekday == weekday,
      );

      widgetsToBuild.add(
        WeeklyScheduleTableCell(lessons: lessonsForWeekday),
      );
    }

    return widgetsToBuild;
  }
}

class WeeklyScheduleTableCell extends StatelessWidget {
  final List<Lesson> lessons;

  const WeeklyScheduleTableCell({
    super.key,
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Text(
        lessons.toString(),
      ),
    );
  }
}

class WeeklyScheduleDaysHeader extends StatelessWidget {
  final double timeColumnWidth;

  const WeeklyScheduleDaysHeader({
    super.key,
    required this.timeColumnWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: timeColumnWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Spacing.small),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.vertical(top: Radii.small),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _getWeekdays()
              .map(
                (day) => Expanded(
                  child: Column(
                    children: [
                      Text(
                        day.weekday.toString(),
                      ),
                      Container(
                        padding: const EdgeInsets.all(Spacing.small),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DateTime.now().weekday == day.weekday
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                        child: Text(
                          _getWeekdayName(day).substring(0, 1),
                          style: TextStyle(
                            color: DateTime.now().weekday == day.weekday
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  /// Gets the weekdays of the current week. From Monday to Friday
  List<DateTime> _getWeekdays() {
    final monday = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1),
    );

    return [
      monday,
      monday.add(const Duration(days: 1)),
      monday.add(const Duration(days: 2)),
      monday.add(const Duration(days: 3)),
      monday.add(const Duration(days: 4)),
    ];
  }

  /// Gets the name of the weekday. Based on the DateTime input
  String _getWeekdayName(DateTime weekday) {
    switch (weekday.weekday) {
      case 1:
        return "Montag";
      case 2:
        return "Dienstag";
      case 3:
        return "Mittwoch";
      case 4:
        return "Donnerstag";
      case 5:
        return "Freitag";
      case 6:
        return "Samstag";
      case 7:
        return "Sonntag";
      default:
        return "";
    }
  }
}

/// Represents a lesson in the weekly schedule
class Lesson extends Equatable {
  final TimeSpan timeSpan;
  final Weekdays weekday;
  final Subject subject;
  final String room;
  final String uuid;

  const Lesson({
    required this.timeSpan,
    required this.weekday,
    required this.subject,
    required this.room,
    required this.uuid,
  });

  @override
  List<Object?> get props => [timeSpan, weekday, subject, room, uuid];

  @override
  bool get stringify => true;
}

/// Represents a subject
class Subject {
  final String subject;
  final Teacher teacher;
  final Color color;

  const Subject({
    required this.subject,
    required this.teacher,
    required this.color,
  });
}

/// Represents a teacher
class Teacher {
  final String firstName;
  final String lastName;
  final Gender gender;
  final String email;
  final Subject? subject;
  final bool favorite;

  Teacher({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    this.subject,
    required this.favorite,
  });
}

/// A time span. Used to represent the time of a lesson
class TimeSpan extends Equatable {
  final TimeOfDay from;
  final TimeOfDay to;

  const TimeSpan({
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [from, to];

  String toFormattedString() {
    return "${from.hour.toString().padLeft(2, "0")}:${from.minute.toString().padLeft(2, "0")} - ${to.hour.toString().padLeft(2, "0")}:${to.minute.toString().padLeft(2, "0")} Uhr";
  }
}

/// The days of a week. From Monday to Friday
enum Weekdays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday;

  int get weekdayAsInt {
    switch (this) {
      case Weekdays.monday:
        return 1;
      case Weekdays.tuesday:
        return 2;
      case Weekdays.wednesday:
        return 3;
      case Weekdays.thursday:
        return 4;
      case Weekdays.friday:
        return 5;
    }
  }
}

/// The gender.
enum Gender {
  male,
  female,
  unspecified;
}
