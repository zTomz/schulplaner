
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/features/calendar/presentation/provider/events_provider.dart';
import 'package:schulplaner/features/hobbies/presentation/provider/hobbies_provider.dart';
import 'package:schulplaner/shared/widgets/generate_with_ai_button.dart';
import 'package:schulplaner/shared/dialogs/custom_dialog.dart';
import 'package:schulplaner/shared/functions/build_body_part.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/services/ai_service.dart';

class GenerateHomeworkProcessingDateWithAiDialog extends HookConsumerWidget {
  final WeeklyScheduleData weeklyScheduleData;
  final Subject subject;
  final DateTime deadline;

  const GenerateHomeworkProcessingDateWithAiDialog({
    super.key,
    required this.weeklyScheduleData,
    required this.subject,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventData = ref.watch(eventsProvider);
    final hobbiesData = ref.watch(hobbiesProvider);

    final difficulty = useState<Difficulty>(Difficulty.easy);

    final errorMessage = useState<String?>(null);
    final loading = useState<bool>(false);

    return CustomDialog(
      icon: const Icon(LucideIcons.sparkles),
      title: const Text("Datum und Zeitspanne generieren"),
      loading:
          eventData.right == null || hobbiesData.right == null || loading.value,
      fatalError: eventData.isLeft() || hobbiesData.isLeft()
          ? Text(
              eventData.left?.toString() ??
                  hobbiesData.left?.toString() ??
                  "Ein unbekannter Fehler ist aufgetreten",
            )
          : null,
      error: errorMessage.value != null ? Text(errorMessage.value ?? "") : null,
      content: buildBodyPart(
        title: const Text("Schwierigkeit"),
        child: SegmentedButton<Difficulty>(
          segments: Difficulty.values
              .map(
                (d) => ButtonSegment(
                  value: d,
                  label: Text(d.name),
                ),
              )
              .toList(),
          selected: {difficulty.value},
          selectedIcon: const SizedBox.shrink(),
          onSelectionChanged: (d) {
            difficulty.value = d.first;
          },
        ),
        padding: const EdgeInsets.only(bottom: Spacing.small),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Schließen"),
        ),
        const SizedBox(width: Spacing.small),
        GenerateWithAiButton(
          onPressed: () async {
            errorMessage.value = null;
            loading.value = true;

            final processingDate =
                await AiService.generateHomeworkProcessingDateWithAi(
              difficulty: difficulty.value,
              weeklyScheduleData: weeklyScheduleData,
              events: eventData.right ?? [],
              hobbies: hobbiesData.right ?? [],
              subject: subject,
              deadline: deadline,
            );

            loading.value = false;

            if (processingDate.isRight() && context.mounted) {
              Navigator.of(context).pop(
                processingDate.right!,
              );
              return;
            } else {
              errorMessage.value = processingDate.left!.message;
              return;
            }
          },
          icon: const Icon(LucideIcons.sparkle),
          child: const Text("Generieren"),
        ),
      ],
    );
  }
}
