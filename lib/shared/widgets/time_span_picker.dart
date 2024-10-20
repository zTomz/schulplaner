import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/widgets/selection_row.dart';

class TimeSpanPicker extends StatelessWidget {
  final void Function(TimeOfDay? from, TimeOfDay? to) onChanged;
  final TimeOfDay? from;
  final TimeOfDay? to;

  const TimeSpanPicker({
    super.key,
    required this.onChanged,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SelectionRow(
          title: const Text("Von:"),
          content: from != null ? Text("${from!.format(context)} Uhr") : null,
          onPressed: () async {
            final result = await showTimePicker(
              context: context,
              initialTime: from ?? TimeOfDay.now(),
            );

            if (result != null) {
              onChanged(result, to);
            }
          },
        ),
        const SizedBox(
          height: Spacing.small,
        ),
        SelectionRow(
          title: const Text("Bis:"),
          content: to != null ? Text("${to!.format(context)} Uhr") : null,
          onPressed: () async {
            final result = await showTimePicker(
              context: context,
              initialTime: to ?? TimeOfDay.now(),
            );

            if (result != null) {
              onChanged(from, result);
            }
          },
        ),
      ],
    );
  }
}
