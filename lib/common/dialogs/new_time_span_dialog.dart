import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/extensions/time_of_day_extension.dart';
import 'package:schulplaner/common/widgets/time_span_picker.dart';
import 'package:schulplaner/common/widgets/weekly_schedule/models.dart';
import 'package:schulplaner/config/theme/numbers.dart';

/// A dialog, which askes the user to enter a new time span. When the user has entered the time span, it will be returned
/// in the .pop() method
class NewTimeSpanDialog extends HookWidget {
  const NewTimeSpanDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final from = useState<TimeOfDay?>(null);
    final to = useState<TimeOfDay?>(null);

    final error = useState<String?>(null);

    return CustomDialog(
      icon: const Icon(LucideIcons.timer),
      title: const Text("Neue Schulzeit"),
      content: TimeSpanPicker(
        onChanged: (fromValue, toValue) {
          from.value = fromValue;
          to.value = toValue;
        },
        from: from.value,
        to: to.value,
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
            if (from.value == null || to.value == null) {
              error.value = "Keine Zeit ausgewählt.";
              return;
            }

            if (from.value! > to.value!) {
              error.value = "Startzeit muss vor der Endzeit liegen.";
              return;
            }

            Navigator.of(context).pop(
              TimeSpan(
                from: from.value!,
                to: to.value!,
              ),
            );
          },
          child: const Text("Hinzufügen"),
        ),
      ],
      error: error.value != null ? Text(error.value!) : null,
    );
  }
}
