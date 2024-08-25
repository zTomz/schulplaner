import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
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

class NewTimeSpanDialog extends HookWidget {
  const NewTimeSpanDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final from = useState<TimeOfDay?>(null);
    final to = useState<TimeOfDay?>(null);

    return CustomDialog(
      icon: const Icon(LucideIcons.timer),
      title: const Text("Neue Schulzeit"),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Von:"),
          const SizedBox(width: Spacing.small),
          _buildTimePicker(
            context,
            onChanged: (newValue) => from.value = newValue,
            value: from.value,
          ),
          const Spacer(),
          const Text("Bis:"),
          const SizedBox(width: Spacing.small),
          _buildTimePicker(
            context,
            onChanged: (newValue) => to.value = newValue,
            value: to.value,
          ),
        ],
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
            // TODO: Show error, that no time is selected
            if (from.value == null || to.value == null) {
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
    );
  }

  Widget _buildTimePicker(
    BuildContext context, {
    required void Function(TimeOfDay value) onChanged,
    required TimeOfDay? value,
  }) {
    return Material(
      borderRadius: const BorderRadius.all(Radii.small),
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radii.small),
        onTap: () async {
          final result = await showTimePicker(
            context: context,
            initialTime: value ?? TimeOfDay.now(),
          );

          if (result != null) {
            onChanged(result);
          }
        },
        child: SizedBox(
          width: 60,
          height: 35,
          child: value != null
              ? Center(
                  child: Text(
                    "${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
