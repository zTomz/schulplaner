import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/extensions/time_of_day_extension.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/common/widgets/time_span_picker.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/weekly_schedule.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/config/theme/numbers.dart';
import 'package:schulplaner/config/theme/text_styles.dart';

class CreateWeeklySchedulePage extends HookWidget {
  const CreateWeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedSchoolTimeCell = useState<SchoolTimeCell?>(null);
    final week = useState<Week>(Week.a);
    final timeSpans = useState<Set<TimeSpan>>({
      const TimeSpan(
        from: TimeOfDay(hour: 7, minute: 30),
        to: TimeOfDay(hour: 8, minute: 0),
      ),
    });
    final lessons = useState<List<Lesson>>([]);

    return GradientScaffold(
      appBar: AppBar(
        title: const Text(
          "Stundenplan erstellen",
          style: TextStyles.title,
        ),
        toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await showDialog<TimeSpan>(
                    context: context,
                    builder: (context) => const NewTimeSpanDialog(),
                  );

                  if (result != null) {
                    timeSpans.value = {...timeSpans.value, result};
                  }
                },
                icon: const Icon(
                  LucideIcons.timer,
                  size: 20,
                ),
                label: const Text("Schulzeit hinzufügen"),
              ),
              const SizedBox(width: Spacing.medium),
              ElevatedButton.icon(
                onPressed: selectedSchoolTimeCell.value == null
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
          const SizedBox(width: Spacing.medium),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          context.pushRoute(const ConfigureHobbyRoute());
        },
        tooltip: "Weiter",
        child: const Icon(LucideIcons.arrow_right),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: WeeklySchedule(
          onLessonEdit: (lesson) {
            // TODO: Edit a lesson
          },
          onWeekTapped: () {
            week.value = week.value.next();
          },
          onDeleteTimeSpan: (timeSpanToDelete) {
            showDialog(
              context: context,
              builder: (context) => CustomDialog.confirmation(
                title: "Schulzeit löschen",
                description:
                    "Soll die Schulzeit ${timeSpanToDelete.from.format(context)} - ${timeSpanToDelete.to.format(context)} wirklich gelöscht werden?",
                onConfirm: () {
                  // Delete the time span from the time spans
                  timeSpans.value = timeSpans.value
                      .where((timeSpan) => timeSpan != timeSpanToDelete)
                      .toSet();

                  // Delete all lessons for the time span
                  lessons.value.removeWhere(
                    (lesson) => lesson.timeSpan == timeSpanToDelete,
                  );

                  Navigator.of(context).pop();
                },
                onCancel: () {
                  Navigator.of(context).pop();
                },
              ),
            );
          },
          onSchoolTimeCellSelected: (schoolTimeCell) {
            // Select the cell. If the cell is already selected, unselect it
            selectedSchoolTimeCell.value =
                schoolTimeCell == selectedSchoolTimeCell.value
                    ? null
                    : schoolTimeCell;
          },
          selectedSchoolTimeCell: selectedSchoolTimeCell.value,
          timeSpans: timeSpans.value,
          lessons: lessons.value,
          week: week.value,
        ),
      ),
    );
  }
}

/// A dialog, which askes the user to enter a new time span. When the user has entered the time span, it will be returned
/// in the .pop() method
class NewTimeSpanDialog extends HookWidget {
  const NewTimeSpanDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final from = useState<TimeOfDay?>(null);
    final to = useState<TimeOfDay?>(null);

    final error = useState<String?>(null);

    return CustomDialog(
      icon: const Icon(LucideIcons.timer),
      title: const Text("Neue Schulzeit"),
      content: TimeSpanPicker(
        onChanged: (fromValue, toValue) {
          from.value = fromValue;
          to.value = toValue;
        },
        from: from.value,
        to: to.value,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Abbrechen"),
        ),
        const SizedBox(width: Spacing.small),
        ElevatedButton(
          onPressed: () {
            if (from.value == null || to.value == null) {
              error.value = "Keine Zeit ausgewählt.";
              return;
            }

            if (from.value! > to.value!) {
              error.value = "Startzeit muss vor der Endzeit liegen.";
              return;
            }

            Navigator.of(context).pop(
              TimeSpan(
                from: from.value!,
                to: to.value!,
              ),
            );
          },
          child: const Text("Hinzufügen"),
        ),
      ],
      error: error.value != null ? Text(error.value!) : null,
    );
  }
}

class NewLessonDialog extends HookWidget {
  const NewLessonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final timeSpan = useState<TimeSpan?>(null);

    return const SizedBox();
  }
}
