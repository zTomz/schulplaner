import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/subject_dialogs.dart';
import 'package:schulplaner/common/functions/build_body_part.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:schulplaner/common/widgets/selection_button.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/models.dart';
import 'package:schulplaner/config/theme/numbers.dart';
import 'package:uuid/uuid.dart';

class EditLessonDialog extends HookWidget {
  final TimeSpan timeSpan;
  final Weekday weekday;

  final Lesson? lesson;

  const EditLessonDialog({
    super.key,
    required this.timeSpan,
    required this.weekday,
    this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    final week = useState<Week>(lesson?.week ?? Week.all);
    final roomController = useTextEditingController(
      text: lesson?.room,
    );
    final subject = useState<Subject?>(lesson?.subject);
    final subjectError = useState<String?>(null);

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
              context,
              title: "Woche:",
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
              error: subjectError.value,
              child: SelectionButton(
                title: "Fach",
                selection: subject.value?.subject,
                onPressed: () async {
                  final result = await showDialog<Subject>(
                    context: context,
                    builder: (context) => const SubjectDialog(),
                  );

                  if (result != null) {
                    subject.value = result;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Schließen"),
        ),
        const SizedBox(width: Spacing.small),
        ElevatedButton(
          onPressed: () {
            const String subjectErrorMessage = "Ein Fach ist erforderlich";

            if (!formKey.currentState!.validate()) {
              if (subject.value == null) {
                subjectError.value = subjectErrorMessage;
              } else {
                subjectError.value = null;
              }

              return;
            }

            if (subject.value == null) {
              subjectError.value = subjectErrorMessage;
              return;
            } else {
              subjectError.value = null;
            }

            Navigator.of(context).pop(
              Lesson(
                timeSpan: timeSpan,
                weekday: weekday,
                week: week.value,
                room: roomController.text,
                subject: subject.value!,
                uuid: lesson?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: const Text("Hinzufügen"),
        ),
      ],
    );
  }
}
