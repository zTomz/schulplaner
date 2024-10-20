import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class WeeklyScheduleTimeCell extends StatelessWidget {
  final void Function(TimeSpan timeSpan) onDeleteTimeSpan;
  final TimeSpan timeSpan;

  const WeeklyScheduleTimeCell({
    super.key,
    required this.onDeleteTimeSpan,
    required this.timeSpan,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => onDeleteTimeSpan(timeSpan),
          borderRadius: BorderRadius.circular(2),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.small),
            child: Text(
              timeSpan.toFormattedString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}

class WeeklyScheduleLessonCell extends StatelessWidget {
  final void Function(List<Lesson> lessons) onTap;
  final void Function(Lesson lesson) onLessonEdit;
  final List<Teacher> teachers;
  final List<Subject> subjects;
  final List<Lesson> lessons;
  final bool isSelected;

  const WeeklyScheduleLessonCell({
    super.key,
    required this.onTap,
    required this.onLessonEdit,
    required this.teachers,
    required this.subjects,
    required this.lessons,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
      child: InkWell(
        onTap: () {
          onTap(lessons);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 3,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            borderRadius: BorderRadius.circular(Spacing.small),
          ),
          child: Row(
            children: lessons
                .map(
                  (lesson) => SchoolCard(
                    lesson: lesson,
                    onEdit: onLessonEdit,
                    teachers: teachers,
                    subjects: subjects,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class SchoolCard extends StatelessWidget {
  final Lesson lesson;
  final List<Subject> subjects;
  final List<Teacher> teachers;
  final void Function(Lesson lesson) onEdit;

  const SchoolCard({
    super.key,
    required this.lesson,
    required this.subjects,
    required this.teachers,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final subject = lesson.getSubject(subjects);
    final teacher = subject?.getTeacher(teachers);

    if (subject == null || teacher == null) {
      return const SizedBox.shrink();
    }

    final foregroundColor = subject.color.computeLuminance() < 0.5
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.onSurface;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.small),
        child: MaterialButton(
          onPressed: () {
            onEdit(lesson);
          },
          padding: const EdgeInsets.all(Spacing.small),
          color: subject.color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radii.small),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconTheme(
              data: Theme.of(context).iconTheme.copyWith(
                    size: 20,
                    color: foregroundColor,
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: foregroundColor,
                        ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 70) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Spacing.small),
                          Wrap(
                            children: [
                              const Icon(LucideIcons.map_pin_house),
                              const SizedBox(width: Spacing.small),
                              Text(
                                lesson.room,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: foregroundColor,
                                    ),
                              ),
                            ],
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(LucideIcons.graduation_cap),
                              const SizedBox(width: Spacing.small),
                              // Doesn't use the lesson.subject.teacher.salutation because, with
                              // the current solution, the line could be wrapped.
                              Text(
                                "${teacher.gender.salutation} ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: foregroundColor,
                                    ),
                              ),
                              Text(
                                teacher.lastName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: foregroundColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
