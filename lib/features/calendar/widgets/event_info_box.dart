import 'package:flutter/material.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/events/edit_homework_dialog.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/services/database_service.dart';
import 'package:schulplaner/features/calendar/functions/get_color_for_event.dart';

class EventInfoBox extends StatelessWidget {
  final Event event;
  final List<Subject> subjects;

  const EventInfoBox({
    super.key,
    required this.event,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.small),
      child: MaterialButton(
        onPressed: () async {
          // TODO: Edit an event
          switch (event.type) {
            case EventTypes.homework:
              final result = await showDialog<HomeworkEvent>(
                context: context,
                builder: (context) => EditHomeworkDialog(
                  homeworkEvent: event as HomeworkEvent,
                ),
              );

              if (result != null && context.mounted) {
                await DatabaseService.uploadEvents(
                  context,
                  events: [result],
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
          ],
        ),
      ),
    );
  }
}
