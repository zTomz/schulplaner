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
                    final currentWeekday = Weekday.fromDateTime(DateTime.now());

                    // Get all lesson for the provided subject
                    List<Lesson> sortedLessons = List<Lesson>.from(lessons);
                    sortedLessons.removeWhere(
                      (lesson) => lesson.subjectUuid != subject?.uuid,
                    );

                    // If the lessons do not have at least one lesson of the provided subject we return
                    if (sortedLessons.isEmpty) {
                      Navigator.of(context).pop(null);
                      return;
                    }

                    // Sort the lessons by weekday
                    sortedLessons.sort(
                      (a, b) => a.weekday < b.weekday ? -1 : 1,
                    );

                    // Get the next lesson. Try to get a lesson where the weekday is larger than the current weekday.
                    // If no lesson is found, than set [lessonIsInSameWeek] to false and try it again without the weekday
                    // comparison
                    bool lessonIsInSameWeek = true;
                    bool lessonWeekdayIsBeforeCurrentWeekday = true;
                    Lesson? nextLesson = firstWhereOrNull<Lesson>(
                      sortedLessons,
                      (lesson) =>
                          lesson.subjectUuid == subject!.uuid &&
                          lesson.weekday.weekdayAsInt >
                              currentWeekday.weekdayAsInt,
                    );

                    if (nextLesson == null) {
                      lessonIsInSameWeek = false;
                      nextLesson = firstWhereOrNull<Lesson>(
                        sortedLessons,
                        (lesson) => lesson.subjectUuid == subject!.uuid,
                      );

                      if (nextLesson != null &&
                          nextLesson.weekday.weekdayAsInt >=
                              currentWeekday.weekdayAsInt) {
                        lessonWeekdayIsBeforeCurrentWeekday = false;
                      }
                    }

                    // If the next lesson is still null, it is not in the weekly schedule. Theoretically this should
                    // never happen
                    if (nextLesson == null) {
                      Navigator.of(context).pop(null);
                      return;
                    }

                    // Get the difference between the current weekday and the next lesson weekday
                    int difference =
                        currentWeekday.getDifference(nextLesson.weekday);

                    // Add a week, because the lesson is on the same day. Now it will be on the same day, but one
                    // week later
                    if (!lessonIsInSameWeek &&
                        lessonWeekdayIsBeforeCurrentWeekday != true) {
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
            label: "Übernächste Stunde",
            icon: const Icon(LucideIcons.calendar_plus_2),
            onPressed: subject == null
                ? null
                : () {
                    final currentWeekday = Weekday.fromDateTime(DateTime.now());

                    // Get all lesson for the provided subject
                    List<Lesson> sortedLessons = List<Lesson>.from(lessons);
                    sortedLessons.removeWhere(
                      (lesson) => lesson.subjectUuid != subject?.uuid,
                    );

                    // If the lessons do not have at least one lesson of the provided subject we return
                    if (sortedLessons.isEmpty) {
                      Navigator.of(context).pop(null);
                      return;
                    }

                    // Sort the lessons by weekday
                    sortedLessons.sort(
                      (a, b) => a.weekday < b.weekday ? -1 : 1,
                    );

                    // Get the next but one lesson. Try to get a lesson where the weekday is larger than the current weekday.
                    // If no lesson is found, than set [lessonIsInSameWeek] to false and try it again without the weekday
                    // comparison
                    Lesson? nextLesson;
                    bool lessonIsInSameWeek = true;
                    bool onlyOneLessonOfSubjectInWeek = false;

                    int lessonsBeforeTheCurrentWeekday = lessons
                        .where((l) =>
                            l.weekday.weekdayAsInt <=
                            currentWeekday.weekdayAsInt)
                        .length;

                    if (sortedLessons.length == 1) {
                      onlyOneLessonOfSubjectInWeek = true;

                      nextLesson = firstWhereOrNull<Lesson>(
                        sortedLessons,
                        (lesson) => lesson.subjectUuid == subject!.uuid,
                      );
                    } else {
                      nextLesson = firstWhereOrNull<Lesson>(
                        sortedLessons
                            .sublist(lessonsBeforeTheCurrentWeekday + 1),
                        (lesson) =>
                            lesson.subjectUuid == subject!.uuid &&
                            lesson.weekday.weekdayAsInt >
                                currentWeekday.weekdayAsInt,
                      );
                    }

                    if (nextLesson == null) {
                      lessonIsInSameWeek = false;
                      nextLesson = firstWhereOrNull<Lesson>(
                        sortedLessons,
                        (lesson) => lesson.subjectUuid == subject!.uuid,
                      );
                    }

                    // If the next lesson is still null, it is not in the weekly schedule. Theoretically this should
                    // never happen
                    if (nextLesson == null) {
                      Navigator.of(context).pop(null);
                      return;
                    }

                    // Get the difference between the current weekday and the next lesson weekday
                    int difference = currentWeekday.getDifference(
                      nextLesson.weekday,
                    );

                    // Add 7, because we want the next but one lesson. So we need to add one week, if there is only one lesson of the provided subject in the week
                    if (onlyOneLessonOfSubjectInWeek) {
                      difference += 7;
                    }

                    // Add a week, because the lesson is on the same day. Now it will be on the same day, but one
                    // week later
                    if (!lessonIsInSameWeek && onlyOneLessonOfSubjectInWeek) {
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
