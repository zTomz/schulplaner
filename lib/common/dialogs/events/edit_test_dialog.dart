import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/weekly_schedule/subject_dialogs.dart';
import 'package:schulplaner/common/extensions/date_time_extension.dart';
import 'package:schulplaner/common/functions/first_where_or_null.dart';
import 'package:schulplaner/common/functions/get_value_or_null.dart';
import 'package:schulplaner/common/functions/handle_state_change_database.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/data_state_widgets.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:schulplaner/common/widgets/time_picker_modal_bottom_sheet.dart';
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
      weeklyScheduleData.hasValue
          ? firstWhereOrNull(
              weeklyScheduleData.value!.$4,
              (s) => s.uuid == testEvent?.subjectUuid,
            )
          : null,
    );
    final date = useState<DateTime?>(testEvent?.date);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return weeklyScheduleData.when(
      data: (data) {
        final lessons = data.$1;
        final subjects = data.$4;
        final teachers = data.$3;

        return CustomDialog.expanded(
          title:
              Text("Arbeit ${testEvent != null ? "bearbeiten" : "hinzufügen"}"),
          icon: const Icon(LucideIcons.briefcase_business),
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
                      final result = await showDialog<Subject>(
                        context: context,
                        builder: (context) => SubjectDialog(
                          subjects: subjects,
                          teachers: teachers,
                          onSubjectChanged: (subject) => onSubjectChanged(
                            context,
                            subject,
                            subjects,
                          ),
                          onTeacherChanged: (teacher) => onTeacherChanged(
                            context,
                            teacher,
                            teachers,
                          ),
                        ),
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
                      final result = await showModalBottomSheet<DateTime>(
                        context: context,
                        builder: (BuildContext context) {
                          return TimePickerModalBottomSheet(
                            subject: subject.value,
                            lessons: lessons,
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
                    name: nameController.text,
                    description: descriptionController.text.getStringOrNull(),
                    subjectUuid: subject.value!.uuid,
                    date: date.value!,
                    praticeDates: [], // TODO: Add practice dates. Maybe with AI
                    uuid: testEvent?.uuid ?? const Uuid().v4(),
                  ),
                );
              },
              child: Text(testEvent == null ? "Hinzufügen" : "Bearbeiten"),
            ),
          ],
        );
      },
      error: (_, __) => const DataErrorWidget(),
      loading: () => const DataLoadingWidget(),
    );
  }
}
