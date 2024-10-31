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

class EventInfoBox extends ConsumerWidget {
  /// The event that should be shown in the info box
  final Event event;

  /// The selected day
  final DateTime day;

  const EventInfoBox({
    super.key,
    required this.event,
    required this.day,
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radii.small),
        ),
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
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.clock,
                          size: 12,
                        ),
                        const SizedBox(width: Spacing.extraSmall),
                        Text(
                          processingDateForDay!.timeSpan.toFormattedString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  // If it is a reminder event, show the place, where the event takes place
                  // if a place is set
                  if (event.type == EventTypes.reminder &&
                      (event as ReminderEvent).place != null)
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.map_pin,
                          size: 12,
                        ),
                        const SizedBox(width: Spacing.extraSmall),
                        Text(
                          (event as ReminderEvent).place!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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
