import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/info_side_panel/event_info_box.dart';
import 'package:schulplaner/shared/widgets/info_side_panel/info_box_position.dart';
import 'package:schulplaner/shared/widgets/info_side_panel/lesson_info_box.dart';

class InfoSidePanel extends StatelessWidget {
  /// The day for which the events should be displayed
  final DateTime day;

  /// A list of events used to display the events for the provided [day]
  final List<Event> events;

  /// A list of lessons used to display the lessons for the provided [day]
  final List<Lesson> lessons;

  /// A list of subjects, used to display the subjects for the provided [lessons]
  final List<Subject> subjects;

  const InfoSidePanel({
    super.key,
    required this.day,
    required this.events,
    required this.lessons,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: const BorderRadius.all(Radii.medium),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: ListView(
          children: [
            _Subtitle(
              count: events.length,
              title: const Text("Ereignisse"),
            ),
            const SizedBox(height: Spacing.small),
            ListView.builder(
              itemCount: events.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final event = events[index];

                return EventInfoBox(
                  event: event,
                  day: day,
                  position: events.length == 1
                      ? InfoBoxPosition.isSingleItem
                      : index == 0
                          ? InfoBoxPosition.top
                          : index == events.length - 1
                              ? InfoBoxPosition.bottom
                              : InfoBoxPosition.middle,
                );
              },
            ),
            _Subtitle(
              count: lessons.length,
              title: const Text("Unterricht"),
            ),
            const SizedBox(height: Spacing.small),
            ListView.builder(
              itemCount: lessons.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final lesson = lessons[index];
            
                return LessonInfoBox(
                  lesson: lesson,
                  subjects: subjects,
                  position: lessons.length == 1
                      ? InfoBoxPosition.isSingleItem
                      : index == 0
                          ? InfoBoxPosition.top
                          : index == lessons.length - 1
                              ? InfoBoxPosition.bottom
                              : InfoBoxPosition.middle,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  final int count;
  final Widget title;

  const _Subtitle({
    required this.count,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  height: 0.5,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: Spacing.small),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!,
              child: title,
            ),
            const SizedBox(width: Spacing.medium),
          ],
        ),
      ),
    );
  }
}
