import 'package:flutter/material.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/models/event.dart';

class EventInfoBox extends StatelessWidget {
  final Event event;

  const EventInfoBox({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.small),
      child: MaterialButton(
        onPressed: () {
          // TODO: Edit an event
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
                color: event.color,
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
                    const SizedBox(height: Spacing.small),
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
