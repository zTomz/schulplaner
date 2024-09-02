// TODO: Delete a time span

import 'package:flutter/material.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/config/theme/numbers.dart';

import 'cells.dart';
import 'days_header.dart';
import 'models.dart';

export 'cells.dart';
export 'days_header.dart';
export 'models.dart';

class WeeklySchedule extends StatelessWidget {
  /// A function that is called when the user clicks on a lesson
  final void Function(Lesson lesson) onLessonEdit;

  /// Called when the week (A, B or All) is tapped.
  final void Function() onWeekTapped;

  /// A function that is called, when the user try's to delete a time span
  final void Function(TimeSpan timeSpan) onDeleteTimeSpan;

  /// A function that is called, when the user selects a time cell in the table
  final void Function(SchoolTimeCell schoolTimeCell) onSchoolTimeCellSelected;

  /// The time cell if any is selected
  final SchoolTimeCell? selectedSchoolTimeCell;

  /// The time spans of the table
  final Set<TimeSpan> timeSpans;

  /// The lessons in the table
  final List<Lesson> lessons;

  /// The current week
  final Week week;

  /// Optional a scroll controller, to controll the table scroll
  final ScrollController? scrollController;

  const WeeklySchedule({
    super.key,
    required this.onLessonEdit,
    required this.onWeekTapped,
    required this.onDeleteTimeSpan,
    required this.onSchoolTimeCellSelected,
    required this.selectedSchoolTimeCell,
    required this.timeSpans,
    required this.lessons,
    required this.week,
    this.scrollController,
  });

  static const double _timeColumnWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeeklyScheduleDaysHeader(
          onWeekTapped: () => onWeekTapped(),
          timeColumnWidth: WeeklySchedule._timeColumnWidth,
          week: week,
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
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
        ),
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
              (lesson.week == week || week == Week.all),
        )
        .toList();

    List<Widget> widgetsToBuild = [
      WeeklyScheduleTimeCell(
        timeSpan: timeSpan,
        onDeleteTimeSpan: onDeleteTimeSpan,
      ),
    ];

    for (Weekday weekday in Weekday.mondayToFriday) {
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
          isSelected: selectedSchoolTimeCell != null &&
              selectedSchoolTimeCell!.weekday == weekday &&
              selectedSchoolTimeCell!.timeSpan == timeSpan,
        ),
      );
    }

    return widgetsToBuild;
  }
}
