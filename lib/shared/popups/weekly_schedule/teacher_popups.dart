// This file contains the dialogs for teachers. This means:
// - The teacher selection modal bottom sheet -> User can select a teacher or has the option
//   to create a new teacher
// - The teacher creation dialog -> User can create a new teacher

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/popups/weekly_schedule/widgets/item_popup_button.dart';
import 'package:schulplaner/shared/functions/build_body_part.dart';
import 'package:schulplaner/shared/functions/get_value_or_null.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/custom_text_field.dart';
import 'package:schulplaner/shared/popups/modal_bottom_sheet.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/models.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/widgets/custom_button.dart';
import 'package:uuid/uuid.dart';

class TeacherModalBottomSheet extends HookConsumerWidget {
  /// If an already selected teacher exists, it will be preselected
  final Teacher? selectedTeacher;

  /// Gets called, when a teacher gets unselected
  final void Function() onTeacherUnselected;

  const TeacherModalBottomSheet({
    super.key,
    this.selectedTeacher,
    required this.onTeacherUnselected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final teachers = weeklyScheduleData.right?.teachers ?? [];

    final selectedTeacher = useState<Teacher?>(this.selectedTeacher);

    return ModalBottomSheet(
      title: const Text("Lehrer"),
      content: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final currentTeacher = teachers[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: Spacing.extraSmall),
                child: ListTile(
                  title: Text(
                    "${currentTeacher.gender.salutation} ${currentTeacher.lastName}",
                  ),
                  leading: Radio<Teacher?>(
                    value: currentTeacher,
                    groupValue: selectedTeacher.value,
                    toggleable: true,
                    onChanged: (teacher) {
                      // If the current selected teacher is the same as the teacher
                      // than we unselect it. Otherwise, we select and return the teacher
                      if (teacher == null) {
                        onTeacherUnselected();
                        selectedTeacher.value = null;
                        return;
                      }

                      Navigator.of(context).pop(teacher);
                    },
                  ),
                  tileColor: Theme.of(context).colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? Radii.small : Radii.extraSmall,
                      bottom: index == teachers.length - 1
                          ? Radii.small
                          : Radii.extraSmall,
                    ),
                  ),
                  trailing: ItemPopupButton(
                    onEdit: () async {
                      final result = await showDialog<Teacher>(
                        context: context,
                        builder: (context) => EditTeacherDialog(
                          teacher: currentTeacher,
                        ),
                      );
                      if (result != null && context.mounted) {
                        ref
                            .read(weeklyScheduleProvider.notifier)
                            .editTeacher(teacher: result);

                        Navigator.of(context).pop(result);
                      }
                    },
                    onDelete: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => CustomDialog.confirmation(
                          title: "Lehrer löschen",
                          description:
                              "Sind Sie sicher, dass Sie diesen Leherer löschen möchten? Wenn Sie dies tun, werden automatisch alle Schulstunden und Fächer, die mit diesen Lehrer belegt sind, mit gelöscht.",
                        ),
                      );

                      if (result == true && context.mounted) {
                        ref
                            .read(weeklyScheduleProvider.notifier)
                            .deleteTeacher(teacher: currentTeacher);

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  onTap: () {
                    // If the current selected teacher is the same as the teacher
                    // than we unselect it. Otherwise, we select and return the teacher
                    if (currentTeacher.uuid == selectedTeacher.value?.uuid) {
                      onTeacherUnselected();
                      selectedTeacher.value = null;
                      return;
                    }

                    Navigator.of(context).pop(currentTeacher);
                  },
                ),
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
                ref
                    .read(weeklyScheduleProvider.notifier)
                    .addTeacher(teacher: result);

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
