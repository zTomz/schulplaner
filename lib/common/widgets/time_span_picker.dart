import 'package:flutter/material.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/widgets/selection_row.dart';

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

  Widget _buildPicker(
    BuildContext context,
    TimeOfDay? value,
    void Function(TimeOfDay? value) onValueChanged,
  ) {
    return Material(
      borderRadius: const BorderRadius.all(Radii.small),
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radii.small),
        onTap: () async {
          final result = await showTimePicker(
            context: context,
            initialTime: value ?? TimeOfDay.now(),
          );

          if (result != null) {
            onValueChanged(result);
          }
        },
        child: SizedBox(
          width: 120,
          height: 35,
          child: value != null
              ? Center(
                  child: Text(
                    "${value.format(context)} Uhr",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
