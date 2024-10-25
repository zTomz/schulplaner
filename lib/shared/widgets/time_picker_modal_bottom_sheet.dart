import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class TimePickerModalBottomSheet extends HookWidget {
  final Subject? subject;
  final WeeklyScheduleData weeklyScheduleData;

  const TimePickerModalBottomSheet({
    super.key,
    required this.subject,
    required this.weeklyScheduleData,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = useState<String?>(null);

    return Container(
      height: errorMessage.value == null ? 250 : 275,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.medium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(Spacing.medium),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(360),
            ),
          ),
          if (errorMessage.value != null) ...[
            Text(
              errorMessage.value!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: Spacing.small),
          ],
          _buildCustomButton(
            context,
            label: "Nächste Stunde",
            indicator: subject == null ? null : weeklyScheduleData
                .getNextLessonDate(
                  subject!,
                  offset: 1,
                )
                .right
                ?.formattedDate,
            icon: const Icon(LucideIcons.calendar_plus),
            onPressed: subject == null
                ? null
                : () {
                    final nextLessonDate = weeklyScheduleData.getNextLessonDate(
                      subject!,
                      offset: 1,
                    );

                    if (nextLessonDate.isLeft()) {
                      errorMessage.value = nextLessonDate.left!.message;
                    }

                    Navigator.of(context).pop(
                      nextLessonDate.right!,
                    );
                  },
          ),
          const SizedBox(height: Spacing.small),
          _buildCustomButton(
            context,
            label: "Übernächste Stunde",
            indicator: subject == null ? null : weeklyScheduleData
                .getNextLessonDate(
                  subject!,
                  offset: 2,
                )
                .right
                ?.formattedDate,
            icon: const Icon(LucideIcons.calendar_plus_2),
            onPressed: subject == null
                ? null
                : () {
                    final nextButOneLessonDate =
                        weeklyScheduleData.getNextLessonDate(
                      subject!,
                      offset: 2,
                    );

                    if (nextButOneLessonDate.isLeft()) {
                      errorMessage.value = nextButOneLessonDate.left!.message;
                    }
                    Navigator.of(context).pop(
                      nextButOneLessonDate.right!,
                    );
                  },
          ),
          const SizedBox(height: Spacing.small),
          _buildCustomButton(
            context,
            label: "Datum auswählen",
            icon: const Icon(LucideIcons.calendar_days),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2008),
                lastDate: DateTime(2055),
              );

              if (date == null && context.mounted) {
                Navigator.of(context).pop(null);
              } else {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(date);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required String label,
    String? indicator,
    required Widget icon,
    required void Function()? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radii.small,
          ),
        ),
        padding: const EdgeInsets.all(
          Spacing.medium,
        ),
      ),
      icon: icon,
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label),
          Text(
            indicator ?? "",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
