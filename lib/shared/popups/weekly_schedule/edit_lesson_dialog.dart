import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/popups/edit_time_span_dialog.dart';
import 'package:schulplaner/shared/popups/modal_bottom_sheet.dart';
import 'package:schulplaner/shared/popups/weekly_schedule/subject_popups.dart';
import 'package:schulplaner/shared/functions/build_body_part.dart';
import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/functions/show_custom_modal_bottom_sheet.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/custom/custom_text_field.dart';
import 'package:schulplaner/shared/widgets/required_field.dart';
import 'package:schulplaner/shared/widgets/custom/custom_button.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/models.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:uuid/uuid.dart';

class EditLessonDialog extends HookConsumerWidget {
  /// The school time cell the lesson will be created in if no lesson is provided
  final SchoolTimeCell? schoolTimeCell;

  /// If null, a new Lesson will be created. Else the provided lesson will be
  /// edited.
  final Lesson? lesson;

  const EditLessonDialog({
    super.key,
    this.schoolTimeCell,
    this.lesson,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final subjects = weeklyScheduleData.right?.subjects ?? [];

    final week = useState<Week>(lesson?.week ?? Week.all);
    final selectedWeekday = useState<Weekday?>(lesson?.weekday);
    final selectedSchoolLessonIds =
        useState<Set<int>?>(lesson?.schoolLessonIds);
    final roomController = useTextEditingController(
      text: lesson?.room,
    );
    final subject = useState<Subject?>(
      firstWhereOrNull(
        subjects,
        (subject) => subject.uuid == lesson?.subjectUuid,
      ),
    );

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
            RequiredField.multiple(
              values: [
                selectedWeekday.value,
                selectedSchoolLessonIds.value,
              ],
              errorTexts: const [
                "Ein Wochentag ist erforderlich.",
                "Es muss eine Unterrichtszeit angegeben werden.",
              ],
              child: CustomButton.selection(
                selection: _getTimeSelection(
                  day: selectedWeekday.value,
                  schoolLessonIds: selectedSchoolLessonIds.value,
                ),
                onPressed: () async {
                  await showCustomModalBottomSheet(
                    context: context,
                    builder: (context) => WeekModalBottomSheet(
                      selectedWeek: week.value,
                      onWeekChanged: (value) {
                        week.value = value;

                        return week.value;
                      },
                      selectedWeekday: selectedWeekday.value,
                      onWeekdayChanged: (value) {
                        selectedWeekday.value = value;

                        return selectedWeekday.value;
                      },
                      selectedSchoolLessonIds: selectedSchoolLessonIds.value,
                      onSchoolLessonsChanged: (value) {
                        // Assign to the ids of the lessons
                        selectedSchoolLessonIds.value = value
                            .map(
                              (lesson) => lesson.id,
                            )
                            .toSet();

                        return selectedSchoolLessonIds.value;
                      },
                    ),
                  );
                },
                child: const Text("Zeit"),
              ),
            ),
            const SizedBox(height: Spacing.small),
            RequiredField(
              errorText: "Ein Fach ist erforderlich.",
              value: subject.value,
              child: CustomButton.selection(
                selection: subject.value?.name,
                onPressed: () async {
                  final result = await showCustomModalBottomSheet<Subject>(
                    context: context,
                    builder: (context) => const SubjectModalBottomSheet(),
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
        if (lesson != null) ...[
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

              if (result == true) {
                await ref
                    .read(weeklyScheduleProvider.notifier)
                    .deleteLesson(lesson: lesson!);

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
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
                schoolLessonIds:
                    lesson?.schoolLessonIds ?? selectedSchoolLessonIds.value!,
                weekday: lesson?.weekday ?? schoolTimeCell!.weekday,
                week: week.value,
                room: roomController.text,
                subjectUuid: subject.value!.uuid,
                uuid: lesson?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: Text(lesson == null ? "Hinzufügen" : "Speichern"),
        ),
      ],
    );
  }

  String? _getTimeSelection({
    required Weekday? day,
    required Set<int>? schoolLessonIds,
  }) {
    if (day == null && schoolLessonIds == null) {
      return null;
    }

    String text = "";

    if (day != null) {
      text += day.name.substring(0, 2);
    }

    if (schoolLessonIds != null) {
      if (text.isNotEmpty) {
        text += ", ";
      }

      text += "${schoolLessonIds.first}. bis ${schoolLessonIds.last}. Stunde";
    }

    return text;
  }
}

class WeekModalBottomSheet extends HookWidget {
  /// The currently selected week
  final Week selectedWeek;

  /// What should happen, when the week gets changed
  final Week Function(Week value) onWeekChanged;

  /// The currently selected weekday
  final Weekday? selectedWeekday;

  /// What should happen, when the current weekday gets changed
  final Weekday? Function(Weekday value) onWeekdayChanged;

  /// A set containing the ids of all selected school lessons
  final Set<int>? selectedSchoolLessonIds;

  final Set<int>? Function(Set<SchoolLesson> value) onSchoolLessonsChanged;

  const WeekModalBottomSheet({
    super.key,
    required this.selectedWeek,
    required this.onWeekChanged,
    required this.selectedWeekday,
    required this.onWeekdayChanged,
    required this.selectedSchoolLessonIds,
    required this.onSchoolLessonsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedWeek = useState<Week>(this.selectedWeek);
    final selectedWeekday = useState<Weekday?>(this.selectedWeekday);
    final selectedSchoolLessonIds =
        useState<Set<int>?>(this.selectedSchoolLessonIds);

    return ModalBottomSheet(
      content: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: buildBodyPart(
              title: const Text("Woche:"),
              child: SegmentedButton(
                onSelectionChanged: (value) {
                  selectedWeek.value = onWeekChanged(value.first);
                },
                segments: Week.values
                    .map(
                      (value) => ButtonSegment(
                        value: value,
                        label: Text(value.name),
                      ),
                    )
                    .toList(),
                selected: {selectedWeek.value},
              ),
              padding: const EdgeInsets.only(bottom: Spacing.small),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: buildBodyPart(
              title: const Text("Wochentag:"),
              child: SegmentedButton(
                onSelectionChanged: (value) {
                  if (value.first == null) {
                    return;
                  }

                  selectedWeekday.value = onWeekdayChanged(value.first!);
                },
                segments: Weekday.mondayToFriday
                    .map(
                      (value) => ButtonSegment(
                        value: value,
                        label: Text(value.name.substring(0, 2)),
                      ),
                    )
                    .toList(),
                selected: {selectedWeekday.value},
              ),
              padding: const EdgeInsets.only(bottom: Spacing.small),
            ),
          ),
          const SizedBox(height: Spacing.small),
          CustomButton.selection(
            selection: selectedSchoolLessonIds.value == null
                ? null
                : "${selectedSchoolLessonIds.value!.first}. bis ${selectedSchoolLessonIds.value!.last}. Stunde",
            onPressed: () async {
              final result =
                  await showCustomModalBottomSheet<Set<SchoolLesson>>(
                context: context,
                builder: (context) => SchoolLessonModalBottomSheet(
                  selectedSchoolLessonIds: selectedSchoolLessonIds.value,
                ),
              );

              if (result != null) {
                selectedSchoolLessonIds.value = onSchoolLessonsChanged(result);
              }
            },
            child: const Text("Unterrichtszeit"),
          ),
        ],
      ),
    );
  }
}

class SchoolLessonModalBottomSheet extends HookConsumerWidget {
  final Set<int>? selectedSchoolLessonIds;

  const SchoolLessonModalBottomSheet({
    super.key,
    required this.selectedSchoolLessonIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final Set<SchoolLesson> schoolLessons = weeklyScheduleData.fold(
      (failure) => {},
      (data) => data.schoolLessons,
    );

    final firstSelected = useState<int?>(selectedSchoolLessonIds?.first);
    final secondSelected = useState<int?>(selectedSchoolLessonIds?.last);

    final Set<SchoolLesson> selectedSchoolLessons = _getSelectedSchoolLessons(
      schoolLessons: schoolLessons,
      firstSelected: firstSelected.value,
      secondSelected: secondSelected.value,
    );

    return ModalBottomSheet(
      title: const Text("Unterrichtszeit"),
      content: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: schoolLessons.length,
            itemBuilder: (context, index) {
              final currentSchoolLesson = schoolLessons.elementAt(index);

              return Padding(
                padding: const EdgeInsets.only(bottom: Spacing.extraSmall),
                child: ListTile(
                  title: Text(
                    "${currentSchoolLesson.lesson}. Stunde",
                  ),
                  subtitle: currentSchoolLesson.timeSpan == null
                      ? null
                      : Text(currentSchoolLesson.timeSpan!.toFormattedString()),
                  tileColor: selectedSchoolLessons.contains(
                    currentSchoolLesson,
                  )
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? Radii.small : Radii.extraSmall,
                      bottom: index == schoolLessons.length - 1
                          ? Radii.small
                          : Radii.extraSmall,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      final result = await showDialog<TimeSpan>(
                        context: context,
                        builder: (context) => EditTimeSpanDialog(
                          timeSpan: currentSchoolLesson.timeSpan,
                        ),
                      );

                      if (result != null) {
                        await ref
                            .read(weeklyScheduleProvider.notifier)
                            .editSchoolLesson(
                              schoolLesson: currentSchoolLesson.copyWith(
                                timeSpan: result,
                              ),
                            );
                      }
                    },
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  onTap: () {
                    if (firstSelected.value == null) {
                      firstSelected.value = currentSchoolLesson.lesson;
                      return;
                    }

                    if (secondSelected.value == null) {
                      secondSelected.value = currentSchoolLesson.lesson;
                      return;
                    }

                    firstSelected.value = null;
                    secondSelected.value = null;

                    firstSelected.value = currentSchoolLesson.lesson;
                  },
                ),
              );
            },
          ),
          const SizedBox(height: Spacing.medium),
          CustomButton(
            onPressed: () async {
              Navigator.of(context).pop(selectedSchoolLessons);
            },
            child: Text(
              selectedSchoolLessonIds == null ? "Hinzufügen" : "Bearbeiten",
            ),
          ),
        ],
      ),
    );
  }

  /// Get all selected school lessons
  Set<SchoolLesson> _getSelectedSchoolLessons({
    required Set<SchoolLesson> schoolLessons,
    required int? firstSelected,
    required int? secondSelected,
  }) {
    if (firstSelected == null && secondSelected == null) {
      return {};
    }

    int first;
    int second;

    if (firstSelected != null && secondSelected == null) {
      first = firstSelected;
      second = firstSelected;
    } else {
      if (firstSelected! > secondSelected!) {
        first = secondSelected;
        second = firstSelected;
      } else {
        first = firstSelected;
        second = secondSelected;
      }
    }

    logger.i(schoolLessons
        .where(
          (element) => element.lesson >= first && element.lesson <= second,
        )
        .toSet());
    return schoolLessons
        .where(
          (element) => element.lesson >= first && element.lesson <= second,
        )
        .toSet();
  }
}
