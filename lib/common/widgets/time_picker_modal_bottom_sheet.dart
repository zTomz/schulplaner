import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/functions/first_where_or_null.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class TimePickerModalBottomSheet extends StatelessWidget {
  final Subject? subject;
  final List<Lesson> lessons;

  const TimePickerModalBottomSheet({
    super.key,
    required this.subject,
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.medium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(Spacing.medium),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(360),
            ),
          ),
          _buildCustomButton(
            label: "Nächste Stunde",
            icon: const Icon(LucideIcons.calendar_plus),
            onPressed: subject == null
                ? null
                : () {
                    // Get the next lesson of the subject
                    final sortedLessons = List<Lesson>.from(lessons);
                    sortedLessons.removeWhere(
                      (lesson) => lesson.subjectUuid != subject?.uuid,
                    );

                    // If the sorted lessons do not have at least one lesson of the provided subject we return
                    if (sortedLessons.isEmpty) {
                      Navigator.of(context).pop(null);
                      return;
                    }

                    // Sort the lessons by weekday
                    sortedLessons.sort(
                      (a, b) => a.weekday.index < b.weekday.index ? -1 : 1,
                    );

                    final nextLesson = firstWhereOrNull<Lesson>(
                      sortedLessons,
                      (lesson) => lesson.subjectUuid == subject!.uuid,
                    );

                    // Get the date of the next lesson, if it is null, return null
                    if (nextLesson == null) {
                      Navigator.of(context).pop(null);
                      return;
                    }
                    final currentWeekday = Weekday.fromDateTime(DateTime.now());

                    // Get the difference between the current weekday and the next lesson weekday
                    final difference =
                        currentWeekday.getDifference(nextLesson.weekday);

                    Navigator.of(context).pop(
                      DateTime.now().add(
                        Duration(days: difference),
                      ),
                    );
                  },
          ),
          const SizedBox(height: Spacing.small),
          _buildCustomButton(
            label: "Übernächste Stunde",
            icon: const Icon(LucideIcons.calendar_plus_2),
            onPressed: subject == null
                ? null
                : () {
                    // Get the next lesson of the subject
                    final sortedLessons = List<Lesson>.from(lessons);
                    sortedLessons.removeWhere(
                      (lesson) => lesson.subjectUuid != subject?.uuid,
                    );

                    // If the sorted lessons do not have at least one lesson of the provided subject we return
                    if (sortedLessons.isEmpty) {
                      Navigator.of(context).pop(null);
                      return;
                    }

                    sortedLessons.sort(
                      (a, b) => a.weekday.index < b.weekday.index ? -1 : 1,
                    );

                    // Get the next but one lesson
                    Lesson? nextLesson;
                    bool onlyOneLessonOfSubjectInWeek = false;
                    if (sortedLessons.sublist(1).isEmpty) {
                      onlyOneLessonOfSubjectInWeek = true;

                      nextLesson = firstWhereOrNull<Lesson>(
                        sortedLessons,
                        (lesson) => lesson.subjectUuid == subject!.uuid,
                      );
                    } else {
                      nextLesson = firstWhereOrNull<Lesson>(
                        sortedLessons.sublist(1),
                        (lesson) => lesson.subjectUuid == subject!.uuid,
                      );
                    }

                    // Get the date of the next lesson, if it is null, return null
                    if (nextLesson == null) {
                      Navigator.of(context).pop(null);
                      return;
                    }
                    final currentWeekday = Weekday.fromDateTime(DateTime.now());

                    // Get the difference between the current weekday and the next lesson weekday
                    int difference =
                        currentWeekday.getDifference(nextLesson.weekday);

                    // Add 7, because we want the next but one lesson. So we need to add one week, if there is only one lesson of the provided subject in the week
                    if (onlyOneLessonOfSubjectInWeek) {
                      difference += 7;
                    }

                    Navigator.of(context).pop(
                      DateTime.now().add(
                        Duration(days: difference),
                      ),
                    );
                  },
          ),
          const SizedBox(height: Spacing.small),
          _buildCustomButton(
            label: "Datum auswählen",
            icon: const Icon(LucideIcons.calendar_days),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2008),
                lastDate: DateTime(2055),
              );

              if (date == null && context.mounted) {
                Navigator.of(context).pop(null);
              } else {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(date);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required String label,
    required Widget icon,
    required void Function()? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radii.small,
          ),
        ),
        padding: const EdgeInsets.all(
          Spacing.medium,
        ),
      ),
      icon: icon,
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(label),
      ),
    );
  }
}
