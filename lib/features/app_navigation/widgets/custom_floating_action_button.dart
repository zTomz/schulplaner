import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/calendar/presentation/provider/events_provider.dart';
import 'package:schulplaner/shared/dialogs/events/edit_homework_dialog.dart';
import 'package:schulplaner/shared/dialogs/events/edit_reminder_dialog.dart';
import 'package:schulplaner/shared/dialogs/events/edit_test_dialog.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class CustomFloatingActionButton extends HookConsumerWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventData = ref.watch(eventsProvider);
    final expandebleFabKey = useMemoized(
      () => GlobalKey<ExpandableFabState>(),
    );

    return eventData.fold(
      (failure) => const SizedBox.shrink(),
      (data) {
        return ExpandableFab(
          key: expandebleFabKey,
          type: ExpandableFabType.up,
          distance: 75,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
            blur: 1,
          ),
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(LucideIcons.plus),
            fabSize: ExpandableFabSize.large,
          ),
          closeButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(LucideIcons.x),
            fabSize: ExpandableFabSize.regular,
          ),
          children: [
            _buildFabOption(
              title: "Hausaufgabe",
              icon: const Icon(LucideIcons.book_open_text),
              onPressed: () async {
                expandebleFabKey.currentState?.toggle();

                final result = await showDialog<HomeworkEvent>(
                  context: context,
                  builder: (context) => const EditHomeworkDialog(),
                );

                if (result != null) {
                  ref.read(eventsProvider.notifier).addEvent(event: result);
                }
              },
            ),
            _buildFabOption(
              title: "Arbeit",
              icon: const Icon(LucideIcons.briefcase_business),
              onPressed: () async {
                expandebleFabKey.currentState?.toggle();
                final result = await showDialog<TestEvent>(
                  context: context,
                  builder: (context) => const EditTestDialog(),
                );

                if (result != null) {
                  ref.read(eventsProvider.notifier).addEvent(event: result);
                }
              },
            ),
            _buildFabOption(
              title: "Erinnerung",
              icon: const Icon(LucideIcons.bell),
              onPressed: () async {
                expandebleFabKey.currentState?.toggle();

                final result = await showDialog<ReminderEvent>(
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

  Widget _buildFabOption({
    required String title,
    required Icon icon,
    required void Function()? onPressed,
  }) {
    return Builder(
      builder: (context) {
        return Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: Spacing.medium),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: onPressed,
              child: icon,
            ),
          ],
        );
      },
    );
  }
}
