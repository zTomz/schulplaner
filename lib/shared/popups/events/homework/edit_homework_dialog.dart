import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/popups/events/event_date_dialog.dart';
import 'package:schulplaner/shared/popups/events/homework/generate_homework_processing_date_with_ai_dialog.dart';
import 'package:schulplaner/shared/functions/show_custom_popups.dart';
import 'package:schulplaner/shared/popups/time_picker_modal_bottom_sheet.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/popups/weekly_schedule/subject_popups.dart';
import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/functions/get_value_or_null.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/custom/custom_button.dart';
import 'package:schulplaner/shared/widgets/custom/custom_text_field.dart';
import 'package:schulplaner/shared/widgets/required_field.dart';
import 'package:uuid/uuid.dart';

class EditHomeworkDialog extends HookConsumerWidget {
  final HomeworkEvent? homeworkEvent;
  final void Function()? onHomeworkDeleted;

  const EditHomeworkDialog({
    super.key,
    this.homeworkEvent,
    this.onHomeworkDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);

    final nameController = useTextEditingController(
      text: homeworkEvent?.name,
    );
    final descriptionController = useTextEditingController(
      text: homeworkEvent?.description,
    );
    final subject = useState<Subject?>(
      firstWhereOrNull(
        weeklyScheduleData.right?.subjects ?? [],
        (s) => s.uuid == homeworkEvent?.subjectUuid,
      ),
    );
    final date = useState<DateTime?>(homeworkEvent?.date);
    final processingDate = useState<ProcessingDate?>(
      homeworkEvent?.processingDate,
    );

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      title: Text(
        "Hausaufgaben ${homeworkEvent == null ? "hinzufügen" : "bearbeiten"}",
      ),
      icon: const Icon(LucideIcons.book_open_text),
      fatalError: weeklyScheduleData.fold(
        (error) => Text(error.toString()),
        (_) => null,
      ),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              validate: true,
              labelText: "Name",
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

                    if (nameController.text.trim() == "Hausaufgabe" ||
                        nameController.text.trim().isEmpty) {
                      nameController.text =
                          "Hausaufgabe ${subject.value?.name}";
                    }
                  }
                },
                child: const Text("Fach"),
              ),
            ),
            const SizedBox(height: Spacing.small),
            RequiredField(
              errorText: "Ein Datum ist erforderlich.",
              value: date.value,
              child: CustomButton.selection(
                selection: date.value?.formattedDate,
                onPressed: () async {
                  final result = await showCustomModalBottomSheet<DateTime>(
                    context: context,
                    builder: (BuildContext context) {
                      return TimePickerModalBottomSheet(
                        subject: subject.value,
                        weeklyScheduleData: weeklyScheduleData.right ??
                            WeeklyScheduleData.empty(),
                      );
                    },
                  );

                  if (result != null) {
                    date.value = result;
                  }
                },
                child: const Text("Datum"),
              ),
            ),
            const SizedBox(height: Spacing.small),
            Row(
              children: [
                Expanded(
                  child: RequiredField(
                    errorText: "Ein Bearbeitungsdatum ist erforderlich.",
                    value: processingDate.value,
                    child: CustomButton.selection(
                      selection: processingDate.value?.formattedDate,
                      onPressed: () async {
                        final result = await showCustomDialog(
                          context: context,
                          builder: (context) => ProcessingDateDialog(
                            processingDate: processingDate.value,
                          ),
                        );

                        if (result != null) {
                          processingDate.value = result;
                        }
                      },
                      child: const Text("Bearbeitungsdatum"),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.small),
                IconButton(
                  onPressed: subject.value != null &&
                          date.value != null &&
                          weeklyScheduleData.isRight()
                      ? () async {
                          final result = await showCustomDialog(
                            context: context,
                            builder: (context) =>
                                GenerateHomeworkProcessingDateWithAiDialog(
                              weeklyScheduleData: weeklyScheduleData.right!,
                              subject: subject.value!,
                              deadline: date.value!,
                            ),
                          );

                          if (result != null) {
                            processingDate.value = result;
                          }
                        }
                      : null,
                  tooltip: "Mit KI generieren",
                  color: Theme.of(context).colorScheme.tertiary,
                  icon: const Icon(LucideIcons.sparkles),
                ),
              ],
            ),
            const SizedBox(height: Spacing.small),
            CustomTextField(
              controller: descriptionController,
              labelText: "Beschreibung",
              maxLines: 3,
              minLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        if (homeworkEvent != null && onHomeworkDeleted != null) ...[
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showCustomDialog<bool>(
                context: context,
                builder: (context) => CustomDialog.confirmation(
                  title: "Hausaufgabe löschen",
                  description:
                      "Sind Sie sich sicher, dass Sie diese Hausaufgabe löschen möchten?",
                ),
              );

              if (result != null && context.mounted) {
                onHomeworkDeleted?.call();
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            icon: const Icon(LucideIcons.trash_2),
            label: const Text("Hausaufgabe löschen"),
          ),
          const Spacer(),
        ],
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Schließen"),
        ),
        const SizedBox(width: Spacing.small),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }

            final event = HomeworkEvent(
              name: nameController.text.trim(),
              subjectUuid: subject.value!.uuid,
              description: descriptionController.text.getStringOrNull(),
              date: date.value!,
              processingDate: processingDate.value!,
              isDone: homeworkEvent?.isDone ?? false,
              uuid: homeworkEvent?.uuid ?? const Uuid().v4(),
            );

            Navigator.pop(
              context,
              event,
            );
          },
          child: Text(homeworkEvent == null ? "Hinzufügen" : "Bearbeiten"),
        ),
      ],
    );
  }
}
