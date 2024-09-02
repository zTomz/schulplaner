import 'package:flutter/material.dart';
import 'package:schulplaner/config/theme/numbers.dart';

class TimeSpanPicker extends StatelessWidget {
  final void Function(TimeOfDay? from, TimeOfDay? to) onChanged;
  final TimeOfDay? from;
  final TimeOfDay? to;

  const TimeSpanPicker({
    super.key,
    required this.onChanged,
    this.from,
    this.to,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("Von:"),
        const SizedBox(width: Spacing.medium),
        _buildPicker(
          context,
          from,
          (value) => onChanged(value, to),
        ),
        const Spacer(),
        const Text("Bis:"),
        const SizedBox(width: Spacing.medium),
        _buildPicker(
          context,
          to,
          (value) => onChanged(from, value),
        ),
      ],
    );
  }

  static Widget _buildPicker(
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
          width: 60,
          height: 35,
          child: value != null
              ? Center(
                  child: Text(
                    "${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
