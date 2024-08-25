import 'package:flutter/material.dart';
import 'package:schulplaner/config/theme/numbers.dart';

import 'cells.dart';
import 'days_header.dart';
import 'models.dart';

export 'cells.dart';
export 'days_header.dart';
export 'models.dart';

class WeeklySchedule extends StatelessWidget {
  final void Function(Lesson lesson) onLessonEdit;
  final void Function(SchoolTimeCell schoolTimeCell) onSchoolTimeCellSelected;
  final SchoolTimeCell? selectedSchoolTimeCell;
  final Set<TimeSpan> timeSpans;
  final List<Lesson> lessons;
  final Week week;

  const WeeklySchedule({
    super.key,
    required this.onLessonEdit,
    required this.onSchoolTimeCellSelected,
    required this.selectedSchoolTimeCell,
    required this.timeSpans,
    required this.lessons,
    required this.week,
  });

  static const double _timeColumnWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeeklyScheduleDaysHeader(
          timeColumnWidth: WeeklySchedule._timeColumnWidth,
          week: week,
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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ElevatedButton.icon(
        //       onPressed: () {
        //         // TODO: Add a time span
        //       },
        //       icon: const Icon(
        //         LucideIcons.timer,
        //         size: 20,
        //       ),
        //       label: const Text("Schulzeit hinzufügen"),
        //     ),
        //     const SizedBox(width: Spacing.medium),
        //     ElevatedButton.icon(
        //       onPressed: selectedSchoolTimeCell == null
        //           ? null
        //           : () {
        //               // TODO: Add a lesson
        //             },
        //       icon: const Icon(
        //         LucideIcons.circle_plus,
        //         size: 20,
        //       ),
        //       label: const Text("Schulstunde hinzufügen"),
        //     ),
        //   ],
        // ),
        const SizedBox(height: Spacing.medium),
      ],
    );
  }

  /// Build all table rows, containing the lessons
  List<TableRow> _buildTableRows() {
    List<TableRow> tableRows = [];

    for (final TimeSpan timeSpan in timeSpans) {
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
    List<Lesson> lessonsToBuild = lessons
        .where(
          // Check if the time span is the same and if the week is the same ( A or B week )
          (lesson) =>
              lesson.timeSpan == timeSpan &&
              (lesson.week == week || lesson.week == Week.all),
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

            onSchoolTimeCellSelected(newCell);
          },
          onLessonEdit: onLessonEdit,
          lessons: lessonsForWeekday,
          isSelected: selectedSchoolTimeCell != null,
        ),
      );
    }

    return widgetsToBuild;
  }
}
