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
  /// A list of already created subjects
  final List<Subject> subjects;

  /// A list of already created teachers
  final List<Teacher> teachers;

  /// A function that is called when a subject is created
  final void Function(Subject subject) onSubjectCreated;

  /// A function that is called when a teacher is created
  final void Function(Teacher teacher) onTeacherCreated;

  const SubjectDialog({
    super.key,
    required this.subjects,
    required this.teachers,
    required this.onSubjectCreated,
    required this.onTeacherCreated,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog.expanded(
      title: const Text("Wähle ein Fach aus"),
      icon: const Icon(LucideIcons.album),
      content: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final currentSubject = subjects[index];
              
              return ListTile(
                title: Text(currentSubject.name),
                onTap: () {
                  Navigator.of(context).pop(subjects[index]);
                },
              );
            },
          ),
          const SizedBox(height: Spacing.medium),
          CustomButton(
            onPressed: () async {
              final result = await showDialog<Subject>(
                context: context,
                builder: (context) => EditSubjectDialog(
                  teachers: teachers,
                  onTeacherCreated: onTeacherCreated,
                ),
              );

              if (result != null && context.mounted) {
                onSubjectCreated(result);
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
  /// The subject to edit. If not provided, the dialog will guide the user to create one
  final Subject? subject;

  /// A list of already created teachers
  final List<Teacher> teachers;

  /// A function that is called when a teacher is created
  final void Function(Teacher teacher) onTeacherCreated;

  const EditSubjectDialog({
    super.key,
    this.subject,
    required this.teachers,
    required this.onTeacherCreated,
  });

  @override
  Widget build(BuildContext context) {
    final subjectController = useTextEditingController(
      text: subject?.name,
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
                    builder: (context) => TeacherDialog(
                      teachers: teachers,
                    ),
                  );

                  if (result != null) {
                    onTeacherCreated(result);
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
                name: subjectController.text,
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
