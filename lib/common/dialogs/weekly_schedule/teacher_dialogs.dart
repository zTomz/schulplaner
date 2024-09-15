// This file contains the dialogs for teachers. This means:
// - The teacher selection dialog -> User can select a teacher or has the option
//   to create a new teacher
// - The teacher creation dialog -> User can create a new teacher

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/functions/build_body_part.dart';
import 'package:schulplaner/common/functions/get_value_or_null.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/models.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:uuid/uuid.dart';

class TeacherDialog extends StatelessWidget {
  /// A list of already created teachers
  final List<Teacher> teachers;

  /// A function is called, whe a teacher is created or edited
  final void Function(Teacher teacher) onTeacherChanged;

  const TeacherDialog({
    super.key,
    required this.teachers,
    required this.onTeacherChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog.expanded(
      title: const Text("Wähle einen Lehrer aus"),
      icon: const Icon(LucideIcons.user_round),
      content: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final currentTeacher = teachers[index];

              return ListTile(
                title: Text(
                  "${currentTeacher.firstName ?? currentTeacher.gender.salutation} ${currentTeacher.lastName}",
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radii.small),
                ),
                trailing: IconButton(
                  onPressed: () async {
                    final result = await showDialog<Teacher>(
                      context: context,
                      builder: (context) => EditTeacherDialog(
                        teacher: currentTeacher,
                      ),
                    );

                    if (result != null && context.mounted) {
                      onTeacherChanged(result);
                      Navigator.of(context).pop(result);
                    }
                  },
                  icon: const Icon(LucideIcons.ellipsis_vertical),
                ),
                onTap: () {
                  Navigator.of(context).pop(teachers[index]);
                },
              );
            },
          ),
          const SizedBox(height: Spacing.medium),
          CustomButton(
            onPressed: () async {
              final result = await showDialog<Teacher>(
                context: context,
                builder: (context) => const EditTeacherDialog(),
              );

              if (result != null && context.mounted) {
                onTeacherChanged(result);
                Navigator.of(context).pop(result);
              }
            },
            child: const Text("Lehrer erstellen"),
          ),
        ],
      ),
    );
  }
}

/// A dialog to create a new teacher. When it pop's it will return the newly created
/// teacher.
class EditTeacherDialog extends HookWidget {
  /// A [Teacher]. If null, a new teacher will be created, otherwise the provided teacher
  /// will be edited
  final Teacher? teacher;

  const EditTeacherDialog({
    super.key,
    this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController(
      text: teacher?.firstName,
    );
    final lastNameController = useTextEditingController(
      text: teacher?.lastName,
    );
    final gender = useState<Gender>(teacher?.gender ?? Gender.divers);

    final emailController = useTextEditingController(
      text: teacher?.email,
    );
    final favorite = useState<bool>(teacher?.favorite ?? false);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      title: Text("${teacher == null ? "Erstelle" : "Bearbeite"} einen Lehrer"),
      icon: const Icon(LucideIcons.user_round),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBodyPart(
              title: const Text("Geschlecht"),
              child: SegmentedButton<String>(
                onSelectionChanged: (value) {
                  gender.value = Gender.fromString(value.first);
                },
                segments: Gender.gendersAsList
                    .map(
                      (value) => ButtonSegment(
                        value: value,
                        label: Text(value),
                      ),
                    )
                    .toList(),
                selected: {gender.value.gender},
              ),
              padding: const EdgeInsets.only(bottom: Spacing.small),
            ),
            CustomTextField(
              controller: firstNameController,
              labelText: "Vorname",
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: Spacing.small),
            CustomTextField(
              controller: lastNameController,
              labelText: "Nachname",
              keyboardType: TextInputType.name,
              validate: true,
            ),
            const SizedBox(height: Spacing.small),
            CustomTextField.email(
              controller: emailController,
              labelText: "E-Mail",
            ),
            const SizedBox(height: Spacing.medium),
            CheckboxListTile(
              title: const Text("Favorit"),
              value: favorite.value,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radii.small),
              ),
              onChanged: (value) {
                favorite.value = value ?? false;
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
              Teacher(
                firstName: firstNameController.text.getStringOrNull(),
                lastName: lastNameController.text,
                email: emailController.text.getStringOrNull(),
                gender: gender.value,
                favorite: favorite.value,
                uuid: teacher?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: Text(teacher == null ? "Erstellen" : "Bearbeiten"),
        ),
      ],
    );
  }
}
