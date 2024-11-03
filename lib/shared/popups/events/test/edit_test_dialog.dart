import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/popups/events/event_date_dialog.dart';
import 'package:schulplaner/shared/popups/events/test/generate_test_processing_dates_with_ai_dialog.dart';
import 'package:schulplaner/shared/popups/weekly_schedule/subject_popups.dart';
import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/functions/get_value_or_null.dart';
import 'package:schulplaner/shared/functions/show_custom_modal_bottom_sheet.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/custom/custom_button.dart';
import 'package:schulplaner/shared/widgets/custom/custom_text_field.dart';
import 'package:schulplaner/shared/widgets/required_field.dart';
import 'package:schulplaner/shared/popups/time_picker_modal_bottom_sheet.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:uuid/uuid.dart';

class EditTestDialog extends HookConsumerWidget {
  final TestEvent? testEvent;
  final void Function()? onTestDeleted;

  const EditTestDialog({
    super.key,
    this.testEvent,
    this.onTestDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);

    final nameController = useTextEditingController(
      text: testEvent?.name,
    );
    final descriptionController = useTextEditingController(
      text: testEvent?.description,
    );
    final subject = useState<Subject?>(
      firstWhereOrNull(
        weeklyScheduleData.right?.subjects ?? [],
        (s) => s.uuid == testEvent?.subjectUuid,
      ),
    );
    final date = useState<DateTime?>(testEvent?.date);
    final processingDates = useState<List<ProcessingDate>?>(
      testEvent?.praticeDates,
    );

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      title: Text("Arbeit ${testEvent != null ? "bearbeiten" : "hinzufügen"}"),
      icon: const Icon(LucideIcons.briefcase_business),
      fatalError: weeklyScheduleData.isLeft()
          ? Text(weeklyScheduleData.left.toString()) // TODO: Better errors
          : null,
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

                    if (nameController.text.trim() == "Arbeit" ||
                        nameController.text.trim().isEmpty) {
                      nameController.text = "Arbeit ${subject.value?.name}";
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
                    errorText: "Mindestens ein Übungsdatum ist erforderlich.",
                    value: processingDates.value,
                    child: CustomButton.selection(
                      selection: processingDates.value == null
                          ? null
                          : processingDates.value!
                              .map((e) => e.formattedDate)
                              .join(", "),
                      onPressed: () async {
                        final result = await showDialog<List<ProcessingDate>>(
                          context: context,
                          builder: (context) => MultipleProssesingDatesDialog(
                            processingDates: processingDates.value,
                          ),
                        );

                        if (result != null) {
                          processingDates.value = [...result];
                        }
                      },
                      child: const Text("Übungsdaten"),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.small),
                IconButton(
                  onPressed: subject.value != null &&
                          date.value != null &&
                          weeklyScheduleData.isRight()
                      ? () async {
                          final result = await showDialog<List<ProcessingDate>>(
                            context: context,
                            builder: (context) =>
                                GenerateTestProcessingDatesWithAi(
                              weeklyScheduleData: weeklyScheduleData.right!,
                              subject: subject.value!,
                              deadline: date.value!,
                            ),
                          );

                          if (result != null) {
                            processingDates.value = result;
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
        if (testEvent != null && onTestDeleted != null) ...[
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => CustomDialog.confirmation(
                  title: "Arbeit löschen",
                  description:
                      "Sind Sie sich sicher, dass Sie diese Arbeit löschen möchten?",
                ),
              );

              if (result != null && context.mounted) {
                onTestDeleted?.call();
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            icon: const Icon(LucideIcons.trash_2),
            label: const Text("Arbeit löschen"),
          ),
          const Spacer(),
        ],
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Abbrechen"),
        ),
        const SizedBox(width: Spacing.small),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }

            Navigator.of(context).pop(
              TestEvent(
                name: nameController.text.trim(),
                description: descriptionController.text.getStringOrNull(),
                subjectUuid: subject.value!.uuid,
                date: date.value!,
                praticeDates: processingDates.value ?? [],
                uuid: testEvent?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: Text(testEvent == null ? "Hinzufügen" : "Bearbeiten"),
        ),
      ],
    );
  }
}
