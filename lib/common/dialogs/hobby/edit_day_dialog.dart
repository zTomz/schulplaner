import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/edit_time_span_dialog.dart';
import 'package:schulplaner/common/functions/build_body_part.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/widgets/required_field.dart';

class EditDayDialog extends HookWidget {
  final TimeInDay? timeInDay;

  const EditDayDialog({
    super.key,
    this.timeInDay,
  });

  @override
  Widget build(BuildContext context) {
    final weekday = useState<Weekday?>(timeInDay?.day);
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
            RequiredField(
              errorText: "Ein Wochentag ist erforderlich.",
              value: weekday.value,
              child: buildBodyPart(
                title: const Text("Wochentag"),
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
                  selected: {weekday.value},
                  onSelectionChanged: (value) {
                    weekday.value = value.first;
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

            Navigator.of(context).pop<TimeInDay>(
              TimeInDay(
                day: weekday.value!,
                timeSpan: timeSpan.value!,
              ),
            );
          },
          child: Text(timeInDay == null ? "Hinzufügen" : "Bearbeiten"),
        ),
      ],
    );
  }
}
