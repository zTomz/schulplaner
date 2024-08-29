// This file contains the dialogs for subjects. This means:
// - The subject selection dialog -> User can select a subject or has the option
//   to create a new subject
// - The subject creation dialog -> User can create a new subject

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/weekly_schedule/teacher_dialogs.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:schulplaner/common/widgets/selection_button.dart';
import 'package:schulplaner/config/theme/numbers.dart';
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
          SelectionButton(
            title: "Fach erstellen",
            selection: null,
            onPressed: () async {
              final result = await showDialog<Subject>(
                context: context,
                builder: (context) => const EditSubjectDialog(),
              );

              if (result != null && context.mounted) {
                Navigator.of(context).pop(result);
              }
            },
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
              error: teacherError.value,
              child: SelectionButton(
                title: "Lehrer",
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
              ),
            ),
            const SizedBox(height: Spacing.small),
            ListTile(
              title: const Text("Color"),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radii.small),
              ),
              onTap: () async {
                color.value = await _chooseColor(
                  context,
                  color.value,
                );
              },
              trailing: Material(
                color: color.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SizedBox.square(dimension: 30),
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
            const String teacherErrorMessage = "Ein Lehrer ist erforderlich";

            if (!formKey.currentState!.validate()) {
              if (teacher.value == null) {
                teacherError.value = teacherErrorMessage;
              } else {
                teacherError.value = null;
              }

              return;
            }

            if (teacher.value == null) {
              teacherError.value = teacherErrorMessage;
              return;
            } else {
              teacherError.value = null;
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

  Future<Color> _chooseColor(BuildContext context, Color color) async {
    // Create a seperate variable, so the input variable is not changed
    Color pickerColor = color;

    final choosenColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wähle eine Farbe'),
        content: SingleChildScrollView(
          child: HueRingPicker(
            pickerColor: pickerColor,
            onColorChanged: (changeColor) {
              pickerColor = changeColor;
            },
            portraitOnly: true,
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
              Navigator.of(context).pop(
                pickerColor,
              );
            },
            child: const Text("Bestätigen"),
          ),
        ],
      ),
    );

    return choosenColor ?? color;
  }
}
