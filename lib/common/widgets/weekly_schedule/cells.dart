import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/config/theme/numbers.dart';


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
  final List<Lesson> lessons;
  final bool isSelected;

  const WeeklyScheduleLessonCell({
    super.key,
    required this.onTap,
    required this.onLessonEdit,
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
  final void Function(Lesson lesson) onEdit;

  const SchoolCard({
    super.key,
    required this.lesson,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = lesson.subject.color.computeLuminance() > 0.5
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
          color: lesson.subject.color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radii.small),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconTheme(
              data: Theme.of(context).iconTheme.copyWith(
                    size: 20,
                    color: lesson.subject.color.computeLuminance() > 0.5
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onSurface,
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.subject.subject,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: textColor,
                        ),
                  ),
                  const SizedBox(height: Spacing.small),
                  Wrap(
                    children: [
                      const Icon(LucideIcons.map_pin_house),
                      const SizedBox(width: Spacing.small),
                      Text(
                        lesson.room,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: textColor,
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
                        "${lesson.subject.teacher.gender.salutation} ",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: textColor,
                            ),
                      ),
                      Text(
                        lesson.subject.teacher.lastName,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: textColor,
                            ),
                      ),
                    ],
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
