import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/extensions/date_time_extension.dart';
import 'package:schulplaner/common/extensions/time_of_day_extension.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/widgets/selection_row.dart';
import 'package:schulplaner/common/widgets/time_span_picker.dart';

class ProcessingDateDialog extends HookWidget {
  const ProcessingDateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final date = useState<DateTime?>(null);
    final durationStart = useState<TimeOfDay?>(null);
    final durationEnd = useState<TimeOfDay?>(null);

    final error = useState<String?>(null);

    return CustomDialog(
      error: error.value != null ? Text(error.value!) : null,
      icon: const Icon(LucideIcons.clock),
      title: const Text("Datum und Zeitspanne wählen"),
      content: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Datum:",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: Spacing.small),
          SelectionRow(
            title: const Text("Tag:"),
            content:
                date.value != null ? Text(date.value!.formattedDate) : null,
            onPressed: () async {
              final result = await showDatePicker(
                context: context,
                initialDate: date.value ?? DateTime.now(),
                firstDate: DateTime.utc(2008),
                lastDate: DateTime.utc(2055),
              );
              if (result != null) {
                date.value = result;
              }
            },
          ),
          const SizedBox(height: Spacing.small),
          const Divider(),
          const SizedBox(height: Spacing.small),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Zeitspanne:",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: Spacing.small),
          TimeSpanPicker(
            from: durationStart.value,
            to: durationEnd.value,
            onChanged: (from, to) {
              durationStart.value = from;
              durationEnd.value = to;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Schließen"),
        ),
        const SizedBox(width: Spacing.small),
        ElevatedButton(
          onPressed: () {
            if (date.value != null &&
                durationStart.value != null &&
                durationEnd.value != null) {
              if (durationStart.value! > durationEnd.value!) {
                error.value = "Startzeit muss vor der Endzeit liegen.";
                return;
              }

              Navigator.of(context).pop(
                ProcessingDate(
                  date: date.value!.copyWith(
                    hour: durationStart.value!.hour,
                    minute: durationStart.value!.minute,
                  ),
                  duration: Duration(
                    minutes: durationEnd.value!.calculateMinutes() -
                        durationStart.value!.calculateMinutes(),
                  ),
                ),
              );
            } else {
              error.value =
                  "Bitte geben Sie ein Datum sowie eine Zeitspanne an.";
            }
          },
          child: const Text("Hinzufügen"),
        ),
      ],
    );
  }
}
