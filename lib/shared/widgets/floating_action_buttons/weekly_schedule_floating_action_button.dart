import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/presentation/provider/weekly_schedule_provider.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/popups/edit_time_span_dialog.dart';
import 'package:schulplaner/shared/popups/weekly_schedule/edit_lesson_dialog.dart';
import 'package:schulplaner/shared/widgets/floating_action_buttons/custom_floating_action_button.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/models.dart';

class WeeklyScheduleFloatingActionButton extends HookConsumerWidget {
  final SchoolTimeCell? selectedSchoolTimeCell;

  const WeeklyScheduleFloatingActionButton({
    super.key,
    required this.selectedSchoolTimeCell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandebleFabKey = useMemoized(
      () => GlobalKey<ExpandableFabState>(),
    );

    return CustomFloatingActionButton(
      expandebleFabKey: expandebleFabKey,
      
      children: [
        CustomFabOption(
          title: const Text("Schulzeit hinzufügen"),
          icon: const Icon(LucideIcons.timer),
          onPressed: () async {
            expandebleFabKey.currentState?.toggle();

            final result = await showDialog<TimeSpan>(
              context: context,
              builder: (context) => const EditTimeSpanDialog(),
            );

            if (result != null) {
              await ref
                  .read(weeklyScheduleProvider.notifier)
                  .addTimeSpan(timeSpan: result);
            }
          },
        ),
        CustomFabOption(
          title: const Text("Schulstunde hinzufügen"),
          icon: const Icon(LucideIcons.circle_plus),
          onPressed: selectedSchoolTimeCell == null
              ? null
              : () async {
                  expandebleFabKey.currentState?.toggle();

                  final result = await showDialog<Lesson>(
                    context: context,
                    builder: (context) => EditLessonDialog(
                      schoolTimeCell: selectedSchoolTimeCell,
                    ),
                  );

                  if (result != null) {
                    await ref.read(weeklyScheduleProvider.notifier).addLesson(
                          lesson: result,
                        );
                  }
                },
        )
      ],
    );
  }
}
