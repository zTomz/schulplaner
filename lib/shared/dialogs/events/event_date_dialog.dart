import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/dialogs/custom_dialog.dart';
import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/shared/extensions/time_of_day_extension.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/widgets/selection_row.dart';
import 'package:schulplaner/shared/widgets/time_span_picker.dart';

class ProcessingDateDialog extends HookWidget {
  final ProcessingDate? processingDate;

  const ProcessingDateDialog({
    super.key,
    this.processingDate,
  });

  @override
  Widget build(BuildContext context) {
    final date = useState<DateTime?>(processingDate?.date);
    final from = useState<TimeOfDay?>(processingDate?.timeSpan.from);
    final to = useState<TimeOfDay?>(processingDate?.timeSpan.to);

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
            from: from.value,
            to: to.value,
            // ignore: no_leading_underscores_for_local_identifiers
            onChanged: (_from, _to) {
              from.value = _from;
              to.value = _to;
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
            if (date.value != null && from.value != null && to.value != null) {
              if (from.value! > to.value!) {
                error.value = "Startzeit muss vor der Endzeit liegen.";
                return;
              }

              Navigator.of(context).pop(
                ProcessingDate(
                  date: date.value!.copyWith(
                    hour: from.value!.hour,
                    minute: from.value!.minute,
                  ),
                  timeSpan: TimeSpan(
                    from: from.value!,
                    to: to.value!,
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
