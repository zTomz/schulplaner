// This file contains the dialogs for subjects. This means:
// - The subject selection modal bottom sheet -> User can select a subject or has the option
//   to create a new subject
// - The subject creation dialog -> User can create a new subject

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/popups/weekly_schedule/teacher_popups.dart';
import 'package:schulplaner/shared/popups/weekly_schedule/widgets/item_popup_button.dart';
import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/functions/show_custom_popups.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/color_choose_list_tile.dart';
import 'package:schulplaner/shared/widgets/custom/custom_color_indicator.dart';
import 'package:schulplaner/shared/widgets/custom/custom_text_field.dart';
import 'package:schulplaner/shared/widgets/custom/custom_button.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/popups/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

class SubjectModalBottomSheet extends ConsumerWidget {
  /// If the subjects are onyl selectable. This means, there is no option to edit them or to add new subjects.
  /// Default is `false`
  final bool onlySelectable;

  const SubjectModalBottomSheet({
    super.key,
    this.onlySelectable = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);

    final subjects = (weeklyScheduleData.right?.subjects ?? [])
      ..sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

    return ModalBottomSheet(
      title: const Text("Fach"),
      content: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final currentSubject = subjects[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: Spacing.extraSmall),
                child: ListTile(
                  title: Text(currentSubject.name),
                  leading: CustomColorIndicator(
                    color: currentSubject.color,
                  ),
                  minLeadingWidth:
                      CustomColorIndicator(color: currentSubject.color)
                          .preferredSize
                          .width,
                  tileColor: Theme.of(context).colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? Radii.small : Radii.extraSmall,
                      bottom: index == subjects.length - 1
                          ? Radii.small
                          : Radii.extraSmall,
                    ),
                  ),
                  trailing: ItemPopupButton(
                    onEdit: () async {
                      final result = await showCustomDialog<Subject>(
                        context: context,
                        builder: (context) => EditSubjectDialog(
                          subject: currentSubject,
                        ),
                      );

                      if (result != null && context.mounted) {
                        ref
                            .read(weeklyScheduleProvider.notifier)
                            .editSubject(subject: result);

                        Navigator.of(context).pop(result);
                      }
                    },
                    onDelete: () async {
                      final result = await showCustomDialog(
                        context: context,
                        builder: (context) => CustomDialog.confirmation(
                          title: "Fach löschen",
                          description:
                              "Sind Sie sicher, dass Sie dieses Fach löschen möchten? Wenn Sie dies tun, werden automatisch alle Schulstunden, die mit diesen Fach belegt sind, mit gelöscht.",
                        ),
                      );

                      if (result == true && context.mounted) {
                        ref
                            .read(weeklyScheduleProvider.notifier)
                            .deleteSubject(subject: result);

                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pop(subjects[index]);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: Spacing.medium),
          CustomButton(
            onPressed: () async {
              final result = await showCustomDialog<Subject>(
                context: context,
                builder: (context) => const EditSubjectDialog(),
              );

              if (result != null && context.mounted) {
                ref
                    .read(weeklyScheduleProvider.notifier)
                    .addSubject(subject: result);

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

class EditSubjectDialog extends HookConsumerWidget {
  /// The subject to edit. If not provided, the dialog will guide the user to create one
  final Subject? subject;

  const EditSubjectDialog({
    super.key,
    this.subject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final teachers = weeklyScheduleData.right?.teachers ?? [];

    final subjectController = useTextEditingController(
      text: subject?.name,
    );
    final teacher = useState<Teacher?>(subject?.getTeacher(teachers));
    if (firstWhereOrNull(teachers, (t) => t.uuid == teacher.value?.uuid) ==
        null) {
      teacher.value = null;
    }
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
            CustomButton.selection(
              selection: teacher.value?.salutation,
              onPressed: () async {
                final result = await showCustomModalBottomSheet<Teacher>(
                  context: context,
                  builder: (context) => TeacherModalBottomSheet(
                    selectedTeacher: teacher.value,
                    onTeacherUnselected: () {
                      teacher.value = null;
                    },
                  ),
                );

                teacher.value = result;
              },
              child: const Text("Lehrer"),
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
                name: subjectController.text.trim(),
                teacherUuid: teacher.value?.uuid,
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
