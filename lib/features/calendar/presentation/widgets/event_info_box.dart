import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/shared/dialogs/events/edit_reminder_dialog.dart';
import 'package:schulplaner/shared/dialogs/events/edit_test_dialog.dart';
import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/dialogs/events/homework/edit_homework_dialog.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/features/calendar/functions/get_color_for_event.dart';

class EventInfoBox extends StatelessWidget {
  /// The event that should be shown in the info box
  final Event event;

  /// The selected day
  final DateTime day;

  /// All events. Used when the user changes the state of the provided event. To update the database
  final List<Event> events;

  /// A list of all subjects
  final List<Subject> subjects;

  /// This function is called, when a event is edited
  final void Function(Event event) onEventEdited;

  /// This function is called, when a event is deleted
  final void Function(Event event) onEventDeleted;

  /// This function is called, when a homework is toggled
  final void Function(HomeworkEvent event, bool newState) onHomeworkToggled;

  const EventInfoBox({
    super.key,
    required this.event,
    required this.day,
    required this.events,
    required this.subjects,
    required this.onEventEdited,
    required this.onEventDeleted,
    required this.onHomeworkToggled,
  });

  @override
  Widget build(BuildContext context) {
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
                  onHomeworkDeleted: () => onEventDeleted(event),
                ),
              );

              if (result != null) {
                onEventEdited(result);
              }
              break;
            case EventTypes.test:
              final result = await showDialog<TestEvent>(
                context: context,
                builder: (context) => EditTestDialog(
                  testEvent: event as TestEvent,
                  onTestDeleted: () => onEventDeleted(event),
                ),
              );

              if (result != null) {
                onEventEdited(result);
              }
              break;
            case EventTypes.reminder:
              final result = await showDialog<ReminderEvent>(
                context: context,
                builder: (context) => EditReminderDialog(
                  reminderEvent: event as ReminderEvent,
                  onReminderDeleted: () => onEventDeleted(event),
                ),
              );

              if (result != null) {
                onEventEdited(result);
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
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: getColorForEvent(event, subjects),
                borderRadius: BorderRadius.circular(360),
              ),
            ),
            const SizedBox(width: Spacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.date.compareWithoutTime(day)
                        ? "${_getDeadlineTextBeforeName(event)}${event.name}"
                        : event.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
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
            if (event.type == EventTypes.homework)
              Checkbox(
                value: (event as HomeworkEvent).isDone,
                onChanged: (value) async {
                  // Update the homework [isDone] status
                  if (value != null) {
                    onHomeworkToggled(event as HomeworkEvent, value);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  String _getDeadlineTextBeforeName(Event event) {
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
