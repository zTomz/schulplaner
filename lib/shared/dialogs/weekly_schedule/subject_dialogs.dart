// This file contains the dialogs for subjects. This means:
// - The subject selection dialog -> User can select a subject or has the option
//   to create a new subject
// - The subject creation dialog -> User can create a new subject

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/shared/dialogs/custom_dialog.dart';
import 'package:schulplaner/shared/dialogs/weekly_schedule/teacher_dialogs.dart';
import 'package:schulplaner/shared/dialogs/weekly_schedule/widgets/item_popup_button.dart';
import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/color_choose_list_tile.dart';
import 'package:schulplaner/shared/widgets/custom_text_field.dart';
import 'package:schulplaner/shared/widgets/required_field.dart';
import 'package:schulplaner/shared/widgets/custom_button.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:uuid/uuid.dart';

class SubjectDialog extends StatelessWidget {
  /// A list of already created subjects
  final List<Subject> subjects;

  /// A list of already created teachers
  final List<Teacher> teachers;

  /// A function that is called, when a subject gets created
  final void Function(Subject subject) onSubjectCreated;

  /// A function that is called, when a subject gets edited
  final void Function(Subject subject) onSubjectEdited;

  /// A function that is called, when a subject gets deleted
  final void Function(Subject subject) onSubjectDeleted;

  /// A function that is called, when a teacher gets created
  final void Function(Teacher teacher) onTeacherCreated;

  /// A function that is called, when a teacher gets edited
  final void Function(Teacher teacher) onTeacherEdited;

  /// A function that is called, when a teacher gets deleted
  final void Function(Teacher teacher) onTeacherDeleted;

  /// If the subjects are onyl selectable. This means, there is no option to edit them or to add new subjects.
  /// Default is `false`
  final bool onlySelectable;

  const SubjectDialog({
    super.key,
    required this.subjects,
    required this.teachers,
    required this.onSubjectCreated,
    required this.onSubjectEdited,
    required this.onSubjectDeleted,
    required this.onTeacherCreated,
    required this.onTeacherEdited,
    required this.onTeacherDeleted,
    this.onlySelectable = false,
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
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radii.small),
                ),
                trailing: ItemPopupButton(
                  onEdit: () async {
                    final result = await showDialog<Subject>(
                      context: context,
                      builder: (context) => EditSubjectDialog(
                        subject: currentSubject,
                        teachers: teachers,
                        onTeacherCreated: onTeacherCreated,
                        onTeacherEdited: onTeacherEdited,
                        onTeacherDeleted: onTeacherDeleted,
                      ),
                    );

                    if (result != null && context.mounted) {
                      onSubjectEdited(result);
                      Navigator.of(context).pop(result);
                    }
                  },
                  onDelete: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => CustomDialog.confirmation(
                        title: "Fach löschen",
                        description:
                            "Sind Sie sicher, dass Sie dieses Fach löschen möchten? Wenn Sie dies tun, werden automatisch alle Schulstunden, die mit diesen Fach belegt sind, mit gelöscht.",
                      ),
                    );

                    if (result == true && context.mounted) {
                      onSubjectDeleted(currentSubject);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                ),
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
                  onTeacherEdited: onTeacherEdited,
                  onTeacherDeleted: onTeacherDeleted,
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

  /// A function that is called, when a teacher gets created
  final void Function(Teacher teacher) onTeacherCreated;

  /// A function that is called, when a teacher gets edited
  final void Function(Teacher teacher) onTeacherEdited;

  /// A function that is called, when a teacher gets deleted
  final void Function(Teacher teacher) onTeacherDeleted;

  const EditSubjectDialog({
    super.key,
    this.subject,
    required this.teachers,
    required this.onTeacherCreated,
    required this.onTeacherEdited,
    required this.onTeacherDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final subjectController = useTextEditingController(
      text: subject?.name,
    );
    final teacher = useState<Teacher?>(firstWhereOrNull(
      teachers,
      (teacher) => teacher.uuid == subject?.teacherUuid,
    ));
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
                      onTeacherCreated: onTeacherCreated,
                      onTeacherEdited: onTeacherEdited,
                      onTeacherDeleted: onTeacherDeleted,
                    ),
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
                name: subjectController.text,
                teacherUuid: teacher.value!.uuid,
                color: color.value,
                uuid: subject?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: Text(subject == null ? "Erstellen" : "Bearbeiten"),
        ),
      ],
    );
  }
}
