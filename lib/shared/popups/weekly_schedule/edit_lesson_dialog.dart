import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/popups/weekly_schedule/subject_popups.dart';
import 'package:schulplaner/shared/functions/build_body_part.dart';
import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/functions/show_custom_modal_bottom_sheet.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/custom/custom_text_field.dart';
import 'package:schulplaner/shared/widgets/required_field.dart';
import 'package:schulplaner/shared/widgets/custom/custom_button.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/models.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:uuid/uuid.dart';

class EditLessonDialog extends HookConsumerWidget {
  /// The school time cell the lesson will be created in if no lesson is provided
  final SchoolTimeCell? schoolTimeCell;

  /// If null, a new Lesson will be created. Else the provided lesson will be
  /// edited.
  final Lesson? lesson;

  const EditLessonDialog({
    super.key,
    this.schoolTimeCell,
    this.lesson,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final subjects = weeklyScheduleData.right?.subjects ?? [];

    final week = useState<Week>(lesson?.week ?? Week.all);
    final roomController = useTextEditingController(
      text: lesson?.room,
    );
    final subject = useState<Subject?>(
      firstWhereOrNull(
        subjects,
        (subject) => subject.uuid == lesson?.subjectUuid,
      ),
    );

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      icon: const Icon(LucideIcons.circle_plus),
      title: Text(
        lesson == null ? "Neue Schulstunde" : "Schulstunde bearbeiten",
      ),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBodyPart(
              title: const Text("Woche:"),
              child: SegmentedButton(
                onSelectionChanged: (value) {
                  week.value = value.first;
                },
                segments: Week.values
                    .map(
                      (value) => ButtonSegment(
                        value: value,
                        label: Text(value.name),
                      ),
                    )
                    .toList(),
                selected: {week.value},
              ),
              padding: const EdgeInsets.only(bottom: Spacing.small),
            ),
            CustomTextField(
              controller: roomController,
              labelText: "Klassenzimmer",
              validate: true,
            ),
            const SizedBox(height: Spacing.small),
            RequiredField(
              errorText: "Ein Fach ist erforderlich.",
              value: subject.value,
              child: CustomButton.selection(
                selection: subject.value?.name,
                onPressed: () async {
                  final result = await showCustomModalBottomSheet<Subject>(
                    context: context,
                    builder: (context) => const SubjectModalBottomSheet(),
                  );

                  if (result != null) {
                    subject.value = result;
                  }
                },
                child: const Text("Fach"),
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (lesson != null) ...[
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => CustomDialog.confirmation(
                  title: "Schulstunde löschen",
                  description:
                      "Sind Sie sich sicher, dass Sie diese Schulstunde löschen möchten?",
                ),
              );

              if (result == true) {
                await ref
                    .read(weeklyScheduleProvider.notifier)
                    .deleteLesson(lesson: lesson!);

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            icon: const Icon(LucideIcons.book_marked),
            label: const Text("Schulstunde löschen"),
          ),
          const Spacer(),
        ],
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Schließen"),
        ),
        const SizedBox(width: Spacing.small),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }

            Navigator.of(context).pop(
              Lesson(
                timeSpan: lesson?.timeSpan ?? schoolTimeCell!.timeSpan,
                weekday: lesson?.weekday ?? schoolTimeCell!.weekday,
                week: week.value,
                room: roomController.text,
                subjectUuid: subject.value!.uuid,
                uuid: lesson?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: Text(lesson == null ? "Hinzufügen" : "Speichern"),
        ),
      ],
    );
  }
}
