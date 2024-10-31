import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/calendar/presentation/provider/events_provider.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/popups/events/edit_reminder_dialog.dart';
import 'package:schulplaner/shared/popups/events/test/edit_test_dialog.dart';
import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/popups/events/homework/edit_homework_dialog.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/features/calendar/functions/get_color_for_event.dart';
import 'package:schulplaner/shared/widgets/custom/custom_color_indicator.dart';
import 'package:schulplaner/shared/widgets/info_side_panel/info_box_position.dart';

class EventInfoBox extends ConsumerWidget {
  /// The event that should be shown in the info box
  final Event event;

  /// The selected day
  final DateTime day;

  /// Where the info box is displayed in the list view. Used for the border radius
  final InfoBoxPosition position;

  const EventInfoBox({
    super.key,
    required this.event,
    required this.day,
    required this.position,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyScheduleData = ref.watch(weeklyScheduleProvider);
    final List<Subject> subjects = weeklyScheduleData.fold(
      (failure) => [],
      (data) => data.subjects,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.small),
      child: MaterialButton(
        onPressed: () async {
          switch (event.type) {
            case EventTypes.homework:
              final result = await showDialog<HomeworkEvent>(
                context: context,
                builder: (context) => EditHomeworkDialog(
                  homeworkEvent: event as HomeworkEvent,
                  onHomeworkDeleted: () async =>
                      await ref.read(eventsProvider.notifier).deleteEvent(
                            event: event,
                          ),
                  // TODO: Add undo feature with SnackBar,
                ),
              );

              if (result != null) {
                await ref.read(eventsProvider.notifier).editEvent(
                      event: result,
                    );
              }
              break;
            case EventTypes.test:
              final result = await showDialog<TestEvent>(
                context: context,
                builder: (context) => EditTestDialog(
                  testEvent: event as TestEvent,
                  onTestDeleted: () async =>
                      await ref.read(eventsProvider.notifier).deleteEvent(
                            event: event,
                          ),
                ),
              );

              if (result != null) {
                await ref.read(eventsProvider.notifier).editEvent(
                      event: result,
                    );
              }
              break;
            case EventTypes.reminder:
              final result = await showDialog<ReminderEvent>(
                context: context,
                builder: (context) => EditReminderDialog(
                  reminderEvent: event as ReminderEvent,
                  onReminderDeleted: () async =>
                      await ref.read(eventsProvider.notifier).deleteEvent(
                            event: event,
                          ),
                ),
              );

              if (result != null) {
                await ref.read(eventsProvider.notifier).editEvent(
                      event: result,
                    );
              }
              break;
            // TODO: Implement editing other events here
            default:
              break;
          }
        },
        padding: const EdgeInsets.all(Spacing.medium),
        shape: position.shape,
        focusElevation: 0,
        elevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: Row(
          children: [
            CustomColorIndicator(
              color: getColorForEvent(event, subjects),
            ),
            const SizedBox(width: Spacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEventDeadline
                        ? "$deadlineTextBeforeName${event.name}"
                        : event.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  // If we have a processing date, show the time span nicely formatted
                  if (processingDateForDay != null)
                    _SpecialInfoBox(
                      icon: const Icon(LucideIcons.clock),
                      text: Text(
                        processingDateForDay!.timeSpan.toFormattedString(),
                      ),
                    ),

                  // If it is a reminder event, show the place, where the event takes place
                  // if a place is set
                  if (event.type == EventTypes.reminder &&
                      (event as ReminderEvent).place != null)
                    _SpecialInfoBox(
                      icon: const Icon(LucideIcons.map_pin),
                      text: Text((event as ReminderEvent).place!),
                    ),

                  // If the event has a description, show it
                  if (event.description != null) ...[
                    const SizedBox(height: Spacing.extraSmall),
                    Text(
                      event.description!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            // If it is a homework event, show a checkbox to toggle the [isDone] status
            if (event.type == EventTypes.homework)
              Checkbox(
                value: (event as HomeworkEvent).isDone,
                onChanged: (value) async {
                  // Update the homework [isDone] status
                  if (value != null) {
                    await ref.read(eventsProvider.notifier).editEvent(
                          event: (event as HomeworkEvent).copyWith(
                            isDone: value,
                          ),
                        );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  /// If it is the deadline of the event and not just a processing date
  bool get isEventDeadline => event.date.compareWithoutTime(day);

  ProcessingDate? get processingDateForDay {
    // If the event is a homework event, than check if the date matches with the selected day.
    // If it does, than return the processing date.
    if (event.type == EventTypes.homework) {
      if ((event as HomeworkEvent)
          .processingDate
          .date
          .compareWithoutTime(day)) {
        return (event as HomeworkEvent).processingDate;
      }
    }

    // If the event is a test event, than iterate over all practice dates, if one matches
    // the selected day, we return it
    if (event.type == EventTypes.test) {
      for (final practiceDate in (event as TestEvent).praticeDates) {
        if (practiceDate.date.compareWithoutTime(day)) {
          return practiceDate;
        }
      }
    }

    return null;
  }

  String get deadlineTextBeforeName {
    switch (event.type) {
      case EventTypes.homework:
        return "Abgabe: ";
      case EventTypes.test:
        return "Prüfungstermin: ";
      case EventTypes.reminder ||
            EventTypes.repeating ||
            EventTypes.unimplemented:
        return "";
    }
  }
}

/// A small box, to display special information about an event. For example
/// its place
class _SpecialInfoBox extends StatelessWidget {
  /// A icon that is displayed before the text
  final Widget icon;

  /// A widget, containing the text
  final Widget text;

  const _SpecialInfoBox({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          IconTheme(
            data: IconThemeData(
              color: Theme.of(context).colorScheme.outline,
              size: 12,
            ),
            child: icon,
          ),
          const SizedBox(width: Spacing.small),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            child: text,
          ),
        ],
      ),
    );
  }
}

