import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/popups/edit_time_span_dialog.dart';
import 'package:schulplaner/shared/functions/build_body_part.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/widgets/custom_button.dart';
import 'package:schulplaner/shared/widgets/required_field.dart';

class EditDayDialog extends HookWidget {
  final TimeInDay? timeInDay;

  const EditDayDialog({
    super.key,
    this.timeInDay,
  });

  @override
  Widget build(BuildContext context) {
    final weekdays = useState<Set<Weekday?>>(
      timeInDay == null
          ? {}
          : {
              timeInDay!.day,
            },
    );

    final timeSpan = useState<TimeSpan?>(timeInDay?.timeSpan);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      title: Text("Tag ${timeInDay == null ? "hinzufügen" : "bearbeiten"}"),
      icon: const Icon(LucideIcons.calendar),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBodyPart(
              title: const Text("Wochentag(e)"),
              child: RequiredField(
                errorText: "Mindestens ein Wochentag ist erforderlich.",
                value: weekdays.value,
                borderRadius: BorderRadius.circular(360),
                child: SegmentedButton<Weekday?>(
                  segments: Weekday.values
                      .map(
                        (day) => ButtonSegment(
                          value: day,
                          tooltip: day.name,
                          label: Text(
                            day.name.substring(0, 1),
                          ),
                        ),
                      )
                      .toList(),
                  selected: weekdays.value,
                  emptySelectionAllowed: true,
                  multiSelectionEnabled: true,
                  onSelectionChanged: (value) {
                    weekdays.value = value;
                  },
                ),
              ),
            ),
            const SizedBox(height: Spacing.small),
            RequiredField(
              errorText: "Eine Zeitspanne ist erforderlich.",
              value: timeSpan.value,
              child: CustomButton.selection(
                selection: timeSpan.value?.toFormattedString(),
                onPressed: () async {
                  final result = await showDialog<TimeSpan>(
                    context: context,
                    builder: (context) => EditTimeSpanDialog(
                      timeSpan: timeSpan.value,
                    ),
                  );

                  if (result != null) {
                    timeSpan.value = result;
                  }
                },
                child: const Text("Zeitspanne"),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Abbrechen"),
        ),
        const SizedBox(width: Spacing.small),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }

            List<TimeInDay> days = [];

            for (Weekday? day in weekdays.value) {
              if (day != null) {
                days.add(
                  TimeInDay(
                    day: day,
                    timeSpan: timeSpan.value!,
                  ),
                );
              }
            }

            Navigator.of(context).pop<List<TimeInDay>>(
              days,
            );
          },
          child: Text(timeInDay == null ? "Hinzufügen" : "Bearbeiten"),
        ),
      ],
    );
  }
}
