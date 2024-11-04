import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/calendar/presentation/provider/events_provider.dart';
import 'package:schulplaner/shared/functions/show_custom_popups.dart';
import 'package:schulplaner/shared/popups/events/homework/edit_homework_dialog.dart';
import 'package:schulplaner/shared/popups/events/edit_reminder_dialog.dart';
import 'package:schulplaner/shared/popups/events/test/edit_test_dialog.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/widgets/floating_action_buttons/custom_floating_action_button.dart';

class EventFloatingActionButton extends HookConsumerWidget {
  const EventFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventData = ref.watch(eventsProvider);
    final expandebleFabKey = useMemoized(
      () => GlobalKey<ExpandableFabState>(),
    );

    return eventData.fold(
      (failure) => const SizedBox.shrink(),
      (data) {
        return CustomFloatingActionButton(
          expandebleFabKey: expandebleFabKey,
          children: [
            CustomFabOption(
              title: const Text("Hausaufgabe"),
              icon: const Icon(LucideIcons.book_open_text),
              onPressed: () async {
                expandebleFabKey.currentState?.toggle();

                final result = await showCustomDialog<HomeworkEvent>(
                  context: context,
                  builder: (context) => const EditHomeworkDialog(),
                );

                if (result != null) {
                  ref.read(eventsProvider.notifier).addEvent(event: result);
                }
              },
            ),
            CustomFabOption(
              title: const Text("Arbeit"),
              icon: const Icon(LucideIcons.briefcase_business),
              onPressed: () async {
                expandebleFabKey.currentState?.toggle();
                final result = await showCustomDialog<TestEvent>(
                  context: context,
                  builder: (context) => const EditTestDialog(),
                );

                if (result != null) {
                  ref.read(eventsProvider.notifier).addEvent(event: result);
                }
              },
            ),
            CustomFabOption(
              title: const Text("Erinnerung"),
              icon: const Icon(LucideIcons.bell),
              onPressed: () async {
                expandebleFabKey.currentState?.toggle();

                final result = await showCustomDialog<ReminderEvent>(
                  context: context,
                  builder: (context) => const EditReminderDialog(),
                );

                if (result != null) {
                  ref.read(eventsProvider.notifier).addEvent(event: result);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
