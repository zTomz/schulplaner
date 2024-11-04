import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/functions/show_custom_popups.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/shared/extensions/time_of_day_extension.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/popups/edit_time_span_dialog.dart';
import 'package:schulplaner/shared/widgets/custom/custom_button.dart';
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

class MultipleProssesingDatesDialog extends HookWidget {
  final List<ProcessingDate>? processingDates;

  const MultipleProssesingDatesDialog({
    super.key,
    this.processingDates,
  });

  @override
  Widget build(BuildContext context) {
    final processingDates = useState<List<ProcessingDate>>(
      this.processingDates ?? [],
    );

    return CustomDialog.expanded(
      icon: const Icon(LucideIcons.calendar_days),
      title: const Text("Übungsdaten erstellen"),
      content: Column(
        children: [
          ListView.builder(
            itemCount: processingDates.value.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final currentProcessingDate = processingDates.value[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: Spacing.small),
                child: ListTile(
                  title: Text(currentProcessingDate.date.formattedDate),
                  subtitle: Text(
                    currentProcessingDate.timeSpan.toFormattedString(),
                  ),
                  tileColor: Theme.of(context).colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? Radii.small : Radii.extraSmall,
                      bottom: index == processingDates.value.length - 1
                          ? Radii.small
                          : Radii.extraSmall,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      processingDates.value = processingDates.value
                          .where((date) => date != currentProcessingDate)
                          .toList();
                    },
                    tooltip: "Löschen",
                    icon: const Icon(LucideIcons.trash_2),
                  ),
                  onTap: () async {
                    final result = await showCustomDialog<TimeSpan>(
                      context: context,
                      builder: (context) => EditTimeSpanDialog(
                        timeSpan: currentProcessingDate.timeSpan,
                      ),
                    );

                    if (result != null) {
                      processingDates.value = processingDates.value
                          .map((date) => date == currentProcessingDate
                              ? date.copyWith(timeSpan: result)
                              : date)
                          .toList();
                    }
                  },
                ),
              );
            },
          ),
          const SizedBox(height: Spacing.medium),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomButton(
                  onPressed: () async {
                    final result = await showCustomDialog<ProcessingDate>(
                      context: context,
                      builder: (context) => const ProcessingDateDialog(),
                    );

                    if (result != null) {
                      processingDates.value = [
                        ...processingDates.value,
                        result
                      ];
                    }
                  },
                  child: const Text("Übungsdatum erstellen"),
                ),
              ),
              const SizedBox(width: Spacing.small),
              Expanded(
                flex: 1,
                child: CustomButton(
                  onPressed: () {
                    Navigator.of(context).pop(processingDates.value);
                  },
                  child: const Text("Fertig"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
