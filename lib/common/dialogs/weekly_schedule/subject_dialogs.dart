// This file contains the dialogs for subjects. This means:
// - The subject selection dialog -> User can select a subject or has the option
//   to create a new subject
// - The subject creation dialog -> User can create a new subject

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/weekly_schedule/teacher_dialogs.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/widgets/color_choose_list_tile.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:uuid/uuid.dart';

class SubjectDialog extends StatelessWidget {
  const SubjectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Load subjects from firebase and display here

    return CustomDialog.expanded(
      title: const Text("Wähle ein Fach aus"),
      icon: const Icon(LucideIcons.album),
      content: Column(
        children: [
          const SizedBox(height: Spacing.medium),
          CustomButton(
            onPressed: () async {
              final result = await showDialog<Subject>(
                context: context,
                builder: (context) => const EditSubjectDialog(),
              );

              if (result != null && context.mounted) {
                Navigator.of(context).pop(result);
              }
            },
            child: const Text("Fach erstellen"),
          ),
        ],
      ),
    );
  }
}

class EditSubjectDialog extends HookWidget {
  final Subject? subject;

  const EditSubjectDialog({
    super.key,
    this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final subjectController = useTextEditingController(
      text: subject?.subject,
    );
    final teacher = useState<Teacher?>(subject?.teacher);
    final teacherError = useState<String?>(null);
    final color = useState<Color>(subject?.color ?? Colors.blue);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      title: Text("${subject == null ? "Erstelle" : "Bearbeite"} ein Fach"),
      icon: const Icon(LucideIcons.user_round),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Spacing.medium),
            CustomTextField(
              controller: subjectController,
              labelText: "Fach",
              validate: true,
            ),
            const SizedBox(height: Spacing.small),
            RequiredField(
              errorText: "Ein Lehrer ist erforderlich.",
              value: teacher.value,
              child: CustomButton.selection(
                selection: teacher.value?.salutation,
                onPressed: () async {
                  final result = await showDialog<Teacher>(
                    context: context,
                    builder: (context) => const TeacherDialog(),
                  );

                  if (result != null) {
                    teacher.value = result;
                    teacherError.value = null;
                  }
                },
                child: const Text("Lehrer"),
              ),
            ),
            const SizedBox(height: Spacing.small),
            ColorChooseListTile(
              color: color.value,
              onColorChanged: (newColor) {
                color.value = newColor;
              },
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
            if (!formKey.currentState!.validate()) {
              return;
            }

            Navigator.of(context).pop(
              Subject(
                subject: subjectController.text,
                teacher: teacher.value!,
                color: color.value,
                uuid: subject?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: const Text("Erstellen"),
        ),
      ],
    );
  }
}
