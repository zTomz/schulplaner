import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/selected_school_time_cell_provider.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/week_provider.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/popups/edit_time_span_dialog.dart';
import 'package:schulplaner/shared/popups/weekly_schedule/edit_lesson_dialog.dart';
import 'package:schulplaner/shared/widgets/data_state_widgets.dart';

import 'cells.dart';
import 'days_header.dart';
import 'models.dart';

export 'cells.dart';
export 'days_header.dart';
export 'models.dart';

class WeeklySchedule extends ConsumerWidget {
  final bool _fieldsAreSelecteble;

  const WeeklySchedule({super.key}) : _fieldsAreSelecteble = true;

  const WeeklySchedule.unselectable({super.key}) : _fieldsAreSelecteble = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawWeeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final selectedSchoolTimeCell = _fieldsAreSelecteble == false
        ? null
        : ref.watch(selectedSchoolTimeCellProvider);
    final week = ref.watch(weekProvider);

    final WeeklyScheduleData weeklyScheduleData = rawWeeklyScheduleData.fold(
      (failure) => WeeklyScheduleData.empty(),
      (data) => data,
    );

    if (weeklyScheduleData.timeSpans.isEmpty) {
      return NoDataWidget(
        addDataButton: ElevatedButton(
          onPressed: () async {
            final result = await showDialog<TimeSpan>(
              context: context,
              builder: (context) => const EditTimeSpanDialog(),
            );

            if (result != null) {
              await ref
                  .read(weeklyScheduleProvider.notifier)
                  .addTimeSpan(timeSpan: result);
            }
          },
          child: const Text("Zeitspanne hinzufügen"),
        ),
      );
    }

    return _WeeklySchedule(
      onLessonEdit: (lesson) async {
        final result = await showDialog<Lesson>(
          context: context,
          builder: (context) => EditLessonDialog(
            lesson: lesson,
            schoolTimeCell: selectedSchoolTimeCell,
          ),
        );

        if (result != null) {
          await ref.read(weeklyScheduleProvider.notifier).editLesson(
                lesson: result,
              );
        }
      },
      onWeekTapped: () {
        ref.watch(weekProvider.notifier).state = week.next;
      },
      onEditTimeSpan: (editedTimeSpan, newValue) async {
        await ref
            .read(weeklyScheduleProvider.notifier)
            .editTimeSpan(oldTimeSpan: editedTimeSpan, newTimeSpan: newValue);
      },
      onDeleteTimeSpan: (timeSpanToDelete) async {
        await ref
            .read(weeklyScheduleProvider.notifier)
            .deleteTimeSpan(timeSpan: timeSpanToDelete);
      },
      onSchoolTimeCellSelected: (schoolTimeCell) {
        // Select the cell. If the cell is already selected, unselect it
        ref.read(selectedSchoolTimeCellProvider.notifier).state =
            schoolTimeCell == selectedSchoolTimeCell ? null : schoolTimeCell;
      },
      selectedSchoolTimeCell: selectedSchoolTimeCell,
      data: weeklyScheduleData,
      week: week,
    );
  }
}

class _WeeklySchedule extends StatelessWidget {
  /// Called when the week (A, B or All) is tapped.
  final void Function() onWeekTapped;

  /// A function that is called, when the user try's to edit a time span
  final void Function(TimeSpan oldTimeSpan, TimeSpan newTimeSpan)
      onEditTimeSpan;

  /// A function that is called, when the user try's to delete a time span
  final void Function(TimeSpan timeSpanToDelete) onDeleteTimeSpan;

  /// A function that is called, when the user selects a time cell in the table
  final void Function(SchoolTimeCell schoolTimeCell) onSchoolTimeCellSelected;

  /// The time cell if any is selected
  final SchoolTimeCell? selectedSchoolTimeCell;

  /// A function that is called when the user clicks on a lesson
  final void Function(Lesson lesson) onLessonEdit;

  /// The data of the weekly schedule
  final WeeklyScheduleData data;

  /// The current week
  final Week week;

  const _WeeklySchedule({
    required this.onWeekTapped,
    required this.onEditTimeSpan,
    required this.onDeleteTimeSpan,
    required this.onSchoolTimeCellSelected,
    required this.selectedSchoolTimeCell,
    required this.onLessonEdit,
    required this.data,
    required this.week,
  });

  static const double _timeColumnWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeeklyScheduleDaysHeader(
          onWeekTapped: () => onWeekTapped(),
          timeColumnWidth: _WeeklySchedule._timeColumnWidth,
          week: week,
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(_WeeklySchedule._timeColumnWidth),
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

    for (final timeSpan in data.timeSpans) {
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
    List<Lesson> lessonsToBuild = data.lessons
        .where(
          // Check if the time span is the same and if the week is the same ( A or B week )
          (lesson) =>
              lesson.timeSpan == timeSpan &&
              (lesson.week == week ||
                  lesson.week == Week.all ||
                  week == Week.all),
        )
        .toList();

    List<Widget> widgetsToBuild = [
      WeeklyScheduleTimeCell(
        timeSpan: timeSpan,
        onEditTimeSpan: onEditTimeSpan,
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
          teachers: data.teachers,
          subjects: data.subjects,
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
