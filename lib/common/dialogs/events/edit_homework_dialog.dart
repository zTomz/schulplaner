import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/events/event_date_dialog.dart';
import 'package:schulplaner/common/dialogs/weekly_schedule/subject_dialogs.dart';
import 'package:schulplaner/common/functions/handle_state_change_database.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/common/widgets/color_choose_list_tile.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/data_state_widgets.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:uuid/uuid.dart';

class EditHomeworkDialog extends HookConsumerWidget {
  const EditHomeworkDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);

    final subject = useState<Subject?>(null);
    final eventDate = useState<EventDate?>(null);
    final color = useState<Color>(Colors.blue);
    final descriptionController = useTextEditingController();

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return weeklyScheduleData.when(
      data: (value) {
        if (value == null) {
          return const DataErrorWidget();
        }

        final List<Teacher> teachers = value.$3;
        final List<Subject> subjects = value.$4;

        return CustomDialog.expanded(
          icon: const Icon(LucideIcons.book_open_text),
          title: const Text("Hausaufgaben erstellen"),
          content: Form(
            key: formKey,
            child: Column(
              children: [
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

                        if (color.value == Colors.blue) {
                          color.value = result.color;
                        }
                      }
                    },
                    child: const Text("Fach"),
                  ),
                ),
                const SizedBox(height: Spacing.small),
                RequiredField(
                  errorText:
                      "Ein Datum und sowie eine Zeitspanne sind erforderlich.",
                  value: eventDate.value,
                  child: CustomButton.selection(
                    selection: eventDate.value?.formattedDate,
                    onPressed: () async {
                      final result = await showDialog<EventDate>(
                        context: context,
                        builder: (context) => const EventDateDialog(),
                      );

                      if (result != null) {
                        eventDate.value = result;
                      }
                    },
                    child: const Text("Datum & Uhrzeit"),
                  ),
                ),
                const SizedBox(height: Spacing.small),
                ColorChooseListTile(
                  color: color.value,
                  onColorChanged: (newColor) {
                    color.value = newColor;
                  },
                ),
                const SizedBox(height: Spacing.small),
                CustomTextField(
                  controller: descriptionController,
                  labelText: "Beschreibung",
                  maxLines: 4,
                )
              ],
            ),
          ),
          actions: [
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
                  subject: subject.value!,
                  description: descriptionController.text,
                  color: color.value,
                  date: eventDate.value!,
                  uuid: const Uuid().v4(),
                );

                Navigator.pop(
                  context,
                  event,
                );
              },
              child: const Text("Hinzufügen"),
            ),
          ],
        );
      },
      error: (_, __) => const DataErrorWidget(),
      loading: () => const DataLoadingWidget(),
    );
  }
}
