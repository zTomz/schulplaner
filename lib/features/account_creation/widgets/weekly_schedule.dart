import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/theme/numbers.dart';

class WeeklySchedule extends StatefulWidget {
  final Set<TimeSpan> timeSpans;
  final List<Lesson> lessons;
  final Week week;

  const WeeklySchedule({
    super.key,
    required this.timeSpans,
    required this.lessons,
    required this.week,
  });

  static const double _timeColumnWidth = 100;

  @override
  State<WeeklySchedule> createState() => _WeeklyScheduleState();
}

class _WeeklyScheduleState extends State<WeeklySchedule> {
  SchoolTimeCell? selectedSchoolTimeCell;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeeklyScheduleDaysHeader(
          timeColumnWidth: WeeklySchedule._timeColumnWidth,
          week: widget.week,
        ),
        Expanded(
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(WeeklySchedule._timeColumnWidth),
            },
            border: TableBorder.all(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(2),
              width: 2,
            ),
            children: _buildTableRows(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add a time span
              },
              icon: const Icon(
                LucideIcons.timer,
                size: 20,
              ),
              label: const Text("Schulzeit hinzufügen"),
            ),
            const SizedBox(width: Spacing.medium),
            ElevatedButton.icon(
              onPressed: selectedSchoolTimeCell == null
                  ? null
                  : () {
                      // TODO: Add a lesson
                    },
              icon: const Icon(
                LucideIcons.circle_plus,
                size: 20,
              ),
              label: const Text("Schulstunde hinzufügen"),
            ),
          ],
        ),
        const SizedBox(height: Spacing.medium),
      ],
    );
  }

  /// Build all table rows, containing the lessons
  List<TableRow> _buildTableRows() {
    List<TableRow> tableRows = [];

    for (final TimeSpan timeSpan in widget.timeSpans) {
      tableRows.add(
        TableRow(
          children: _buildLessonsForTimeSpan(timeSpan),
        ),
      );
    }

    return tableRows;
  }

  /// Build all lessons for a given time span. It takes in to account the week ( A or B )
  /// given by the widget constructor and the time span
  List<Widget> _buildLessonsForTimeSpan(TimeSpan timeSpan) {
    List<Lesson> lessonsToBuild = widget.lessons
        .where(
          // Check if the time span is the same and if the week is the same ( A or B week )
          (lesson) =>
              lesson.timeSpan == timeSpan &&
              (lesson.week == widget.week || lesson.week == Week.all),
        )
        .toList();

    List<Widget> widgetsToBuild = [
      WeeklyScheduleTimeCell(timeSpan: timeSpan),
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
        WeeklyScheduleLessonCell(
          onTap: (List<Lesson> _) {
            final newCell = SchoolTimeCell(
              weekday: weekday,
              timeSpan: timeSpan,
            );
            setState(() {
              selectedSchoolTimeCell = newCell == selectedSchoolTimeCell
                  ? null
                  : SchoolTimeCell(
                      weekday: weekday,
                      timeSpan: timeSpan,
                    );
            });
          },
          lessons: lessonsForWeekday,
          isSelected: selectedSchoolTimeCell?.weekday == weekday &&
              selectedSchoolTimeCell?.timeSpan == timeSpan,
        ),
      );
    }

    return widgetsToBuild;
  }
}

class WeeklyScheduleTimeCell extends StatelessWidget {
  final TimeSpan timeSpan;

  const WeeklyScheduleTimeCell({
    super.key,
    required this.timeSpan,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.small),
        child: Text(
          timeSpan.toFormattedString(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class SchoolTimeCell extends Equatable {
  final Weekdays weekday;
  final TimeSpan timeSpan;

  const SchoolTimeCell({
    required this.weekday,
    required this.timeSpan,
  });

  @override
  List<Object?> get props => [weekday, timeSpan];
}

class WeeklyScheduleLessonCell extends StatelessWidget {
  final void Function(List<Lesson> lessons) onTap;
  final List<Lesson> lessons;
  final bool isSelected;

  const WeeklyScheduleLessonCell({
    super.key,
    required this.onTap,
    required this.lessons,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
      child: InkWell(
        onTap: () {
          onTap(lessons);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 3,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            borderRadius: BorderRadius.circular(Spacing.small),
          ),
          child: Row(
            children: lessons
                .map(
                  (lesson) => SchoolCard(
                    lesson: lesson,
                    onEdit: (lesson) {
                      // TODO: Handle edit school card
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class SchoolCard extends StatelessWidget {
  final Lesson lesson;
  final void Function(Lesson lesson) onEdit;

  const SchoolCard({
    super.key,
    required this.lesson,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = lesson.subject.color.computeLuminance() > 0.5
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.onSurface;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.small),
        child: MaterialButton(
          onPressed: () {
            onEdit(lesson);
          },
          padding: const EdgeInsets.all(Spacing.small),
          color: lesson.subject.color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radii.small),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconTheme(
              data: IconThemeData(
                size: 20,
                color: lesson.subject.color.computeLuminance() > 0.5
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.onSurface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.subject.subject,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: textColor,
                        ),
                  ),
                  const SizedBox(height: Spacing.small),
                  Wrap(
                    children: [
                      const Icon(LucideIcons.map_pin_house),
                      const SizedBox(width: Spacing.small),
                      Text(
                        lesson.room,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: textColor,
                            ),
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(LucideIcons.graduation_cap),
                      const SizedBox(width: Spacing.small),
                      Text(
                        "${lesson.subject.teacher.gender.genderAsString} ",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: textColor,
                            ),
                      ),
                      Text(
                        lesson.subject.teacher.lastName,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: textColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The header of the weekly schedule. Shows the day and it's date. As well as the current
/// week
class WeeklyScheduleDaysHeader extends StatelessWidget {
  final double timeColumnWidth;
  final Week week;

  const WeeklyScheduleDaysHeader({
    super.key,
    required this.timeColumnWidth,
    required this.week,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: timeColumnWidth,
          child: Text(
            week.name,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: DateTime.now().weekday == day.weekday
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                  ),
                            ),
                          ),
                          Text(
                            day.day.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
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
  final Week week;
  final Subject subject;
  final String room;
  final String uuid;

  const Lesson({
    required this.timeSpan,
    required this.weekday,
    required this.week,
    required this.subject,
    required this.room,
    required this.uuid,
  });

  @override
  List<Object?> get props => [timeSpan, weekday, week, subject, room, uuid];

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

  String get genderAsString {
    switch (this) {
      case Gender.male:
        return "Herr";
      case Gender.female:
        return "Frau";
      case Gender.unspecified:
        return "";
    }
  }
}

/// An enum to represent the week. Either A or B or All
enum Week {
  a(name: "A"),
  b(name: "B"),
  all(name: "All");

  final String name;

  const Week({
    required this.name,
  });
}
