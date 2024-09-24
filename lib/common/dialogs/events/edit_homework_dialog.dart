import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/common/widgets/time_picker_modal_bottom_sheet.dart';
import 'package:schulplaner/config/constants/numbers.dart';
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

    final subject = useState<Subject?>(
      weeklyScheduleData.hasValue
          ? firstWhereOrNull(
              weeklyScheduleData.value!.$4,
              (s) => s.uuid == homeworkEvent?.subjectUuid,
            )
          : null,
    );
    final date = useState<DateTime?>(homeworkEvent?.date);
    final nameController = useTextEditingController(
      text: homeworkEvent?.name,
    );
    final descriptionController = useTextEditingController(
      text: homeworkEvent?.description,
    );

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return weeklyScheduleData.when(
      data: (value) {
        final List<Lesson> lessons = value.$1;
        final List<Teacher> teachers = value.$3;
        final List<Subject> subjects = value.$4;

        return CustomDialog.expanded(
          icon: const Icon(LucideIcons.book_open_text),
          title: Text(
            "Hausaufgaben ${homeworkEvent == null ? "hinzufügen" : "bearbeiten"}",
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

                      // final result = await showDialog<EventDate>(
                      //   context: context,
                      //   builder: (context) => const EventDateDialog(),
                      // );

                      // if (result != null) {
                      //   eventDate.value = result;
                      // }
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
            if (homeworkEvent != null && onHomeworkDeleted != null) ...[
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => CustomDialog.confirmation(
                      title: "Hausaufgabe löschen",
                      description:
                          "Sind Sie sich sicher, dass Sie diese Hausaufgabe löschen möchten?",
                    ),
                  );

                  if (result != null && context.mounted) {
                    onHomeworkDeleted?.call();
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
      },
      error: (_, __) => const DataErrorWidget(),
      loading: () => const DataLoadingWidget(),
    );
  }
}
