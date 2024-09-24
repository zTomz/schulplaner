import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/events/edit_fixed_event_dialog.dart';
import 'package:schulplaner/common/dialogs/events/edit_test_dialog.dart';
import 'package:schulplaner/common/functions/close_all_dialogs.dart';
import 'package:schulplaner/common/functions/first_where_or_null.dart';
import 'package:schulplaner/common/services/snack_bar_service.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/events/edit_homework_dialog.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/services/database_service.dart';
import 'package:schulplaner/features/calendar/functions/get_color_for_event.dart';

class EventInfoBox extends StatelessWidget {
  final Event event;
  final List<Event> events;
  final List<Subject> subjects;

  const EventInfoBox({
    super.key,
    required this.event,
    required this.events,
    required this.subjects,
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
                  onHomeworkDeleted: () async {
                    List<Event> eventsList = List<Event>.from(events);
                    eventsList.removeWhere((e) => e.uuid == event.uuid);

                    await DatabaseService.uploadEvents(
                      context,
                      events: eventsList,
                    );

                    if (context.mounted) {
                      await closeAllDialogs(context);
                    }
                    if (context.mounted) {
                      final eventSubject = firstWhereOrNull(
                        subjects,
                        (subject) =>
                            subject.uuid ==
                            (event as HomeworkEvent).subjectUuid,
                      );
                      SnackBarService.show(
                        context: context,
                        content: Text(
                          "Die Hausaufgabe für ${eventSubject?.name ?? "das angegebenen Fach"} wurde gelöscht.",
                        ),
                        type: CustomSnackbarType.info,
                      );
                    }
                  },
                ),
              );

              if (result != null && context.mounted) {
                List<Event> eventsList = List<Event>.from(events);
                eventsList.removeWhere((e) => e.uuid == result.uuid);

                await DatabaseService.uploadEvents(
                  context,
                  events: [...eventsList, result],
                );
              }
              break;
            case EventTypes.test:
              final result = await showDialog<TestEvent>(
                context: context,
                builder: (context) => EditTestDialog(
                  testEvent: event as TestEvent,
                  onTestDeleted: () async {
                    List<Event> eventsList = List<Event>.from(events);
                    eventsList.removeWhere((e) => e.uuid == event.uuid);

                    await DatabaseService.uploadEvents(
                      context,
                      events: eventsList,
                    );

                    if (context.mounted) {
                      await closeAllDialogs(context);
                    }
                    if (context.mounted) {
                      final eventSubject = firstWhereOrNull(
                        subjects,
                        (subject) =>
                            subject.uuid ==
                            (event as HomeworkEvent).subjectUuid,
                      );
                      SnackBarService.show(
                        context: context,
                        content: Text(
                          "Die Hausaufgabe für ${eventSubject?.name ?? "das angegebenen Fach"} wurde gelöscht.",
                        ),
                        type: CustomSnackbarType.info,
                      );
                    }
                  },
                ),
              );

              if (result != null && context.mounted) {
                List<Event> eventsList = List<Event>.from(events);
                eventsList.removeWhere((e) => e.uuid == result.uuid);

                await DatabaseService.uploadEvents(
                  context,
                  events: [...eventsList, result],
                );
              }
              break;
            case EventTypes.fixed:
              final result = await showDialog<FixedEvent>(
                context: context,
                builder: (context) => EditFixedEventDialog(
                  fixedEvent: event as FixedEvent,
                  onFixedEventDeleted: () async {
                    List<Event> eventsList = List<Event>.from(events);
                    eventsList.removeWhere((e) => e.uuid == event.uuid);

                    await DatabaseService.uploadEvents(
                      context,
                      events: eventsList,
                    );

                    if (context.mounted) {
                      await closeAllDialogs(context);
                    }
                    if (context.mounted) {
                      final eventSubject = firstWhereOrNull(
                        subjects,
                        (subject) =>
                            subject.uuid ==
                            (event as HomeworkEvent).subjectUuid,
                      );
                      SnackBarService.show(
                        context: context,
                        content: Text(
                          "Die Hausaufgabe für ${eventSubject?.name ?? "das angegebenen Fach"} wurde gelöscht.",
                        ),
                        type: CustomSnackbarType.info,
                      );
                    }
                  },
                ),
              );

              if (result != null && context.mounted) {
                List<Event> eventsList = List<Event>.from(events);
                eventsList.removeWhere((e) => e.uuid == result.uuid);

                await DatabaseService.uploadEvents(
                  context,
                  events: [...eventsList, result],
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
                    event.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (event.type == EventTypes.fixed &&
                      (event as FixedEvent).place != null)
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.map_pin,
                          size: 12,
                        ),
                        const SizedBox(width: Spacing.extraSmall),
                        Text(
                          (event as FixedEvent).place!,
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
                  List<Event> eventsList = List<Event>.from(events);
                  eventsList.removeWhere((e) => e.uuid == event.uuid);
                  eventsList.add(
                    (event as HomeworkEvent).copyWith(isDone: value ?? false),
                  );

                  await DatabaseService.uploadEvents(
                    context,
                    events: eventsList,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
