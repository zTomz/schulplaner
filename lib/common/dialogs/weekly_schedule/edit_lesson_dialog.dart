import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/weekly_schedule/subject_dialogs.dart';
import 'package:schulplaner/common/functions/build_body_part.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/models.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:uuid/uuid.dart';

class EditLessonDialog extends HookWidget {
  /// The school time cell the lesson will be created in if no lesson is provided
  final SchoolTimeCell? schoolTimeCell;

  /// If null, a new Lesson will be created. Else the provided lesson will be
  /// edited.
  final Lesson? lesson;

  /// A list of already created subjects
  final List<Subject> subjects;

  /// A list of already created teachers
  final List<Teacher> teachers;

  /// If not null, this function is called, when the user tries to delete the
  /// lesson.
  final void Function(Lesson lesson)? onLessonDeleted;

  /// A function that is called, when a subject gets created or edited
  final void Function(Subject subject) onSubjectChanged;

  /// A function that is called, when a teacher gets created or edited
  final void Function(Teacher teacher) onTeacherChanged;

  const EditLessonDialog({
    super.key,
    this.schoolTimeCell,
    this.lesson,
    required this.subjects,
    required this.teachers,
    required this.onLessonDeleted,
    required this.onSubjectChanged,
    required this.onTeacherChanged,
  });

  @override
  Widget build(BuildContext context) {
    final week = useState<Week>(lesson?.week ?? Week.all);
    final roomController = useTextEditingController(
      text: lesson?.room,
    );
    final subject = useState<Subject?>(lesson?.subject);

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
              title: const Text("Woche:"),
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
                      onSubjectChanged: onSubjectChanged,
                      onTeacherChanged: onTeacherChanged,
                    ),
                  );

                  if (result != null) {
                    subject.value = result;
                  }
                },
                child: const Text("Fach"),
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (onLessonDeleted != null) ...[
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => CustomDialog.confirmation(
                  title: "Schulstunde löschen",
                  description:
                      "Sind Sie sich sicher, dass Sie diese Schulstunde löschen möchten?",
                ),
              );

              if (result == true && context.mounted && lesson != null) {
                onLessonDeleted!.call(lesson!);
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            icon: const Icon(LucideIcons.book_marked),
            label: const Text("Schulstunde löschen"),
          ),
          const Spacer(),
        ],
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
              Lesson(
                timeSpan: lesson?.timeSpan ?? schoolTimeCell!.timeSpan,
                weekday: lesson?.weekday ?? schoolTimeCell!.weekday,
                week: week.value,
                room: roomController.text,
                subject: subject.value!,
                uuid: lesson?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: Text(lesson == null ? "Hinzufügen" : "Speichern"),
        ),
      ],
    );
  }
}
