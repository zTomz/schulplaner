import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/shared/popups/custom_dialog.dart';
import 'package:schulplaner/shared/extensions/time_of_day_extension.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/widgets/time_span_picker.dart';
import 'package:schulplaner/config/constants/numbers.dart';

/// A dialog, which askes the user to enter a new time span. When the user has entered the time span, it will be returned
/// in the .pop() method
class EditTimeSpanDialog extends HookWidget {
  /// Optional. A preset time span
  final TimeSpan? timeSpan;

  /// Optional. When the user wants to delete the time span. Make sure, that when
  /// onDelete is not null, that the time span is not null as well
  final void Function()? onDelete;

  const EditTimeSpanDialog({
    super.key,
    this.timeSpan,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final from = useState<TimeOfDay?>(timeSpan?.from);
    final to = useState<TimeOfDay?>(timeSpan?.to);

    final error = useState<String?>(null);

    return _buildDialog(
      context,
      title: Text(
        timeSpan == null ? "Neue Zeitspanne" : "Zeitspanne bearbeiten",
      ),
      icon: const Icon(LucideIcons.timer),
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
          child: Text(timeSpan == null ? "Hinzufügen" : "Bearbeiten"),
        ),
      ],
      onDelete: onDelete == null || timeSpan == null
          ? null
          : IconButton(
              icon: const Icon(LucideIcons.trash_2),
              tooltip: "Zeitspanne löschen",
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                onDelete!();
              },
            ),
      error: error.value,
    );
  }

  /// Build an expanded dialog, if onDelet widget is not null. If it is null, build
  /// a normal custom dialog
  Widget _buildDialog(
    BuildContext context, {
    required Widget title,
    required Widget icon,
    required Widget content,
    required List<Widget> actions,
    required Widget? onDelete,
    required String? error,
  }) {
    if (onDelete != null) {
      return CustomDialog.expanded(
        icon: icon,
        title: title,
        content: content,
        actions: [
          onDelete,
          const Spacer(),
          ...actions,
        ],
        error: error != null ? Text(error) : null,
      );
    }

    return CustomDialog(
      icon: icon,
      title: title,
      content: content,
      actions: actions,
      error: error != null ? Text(error) : null,
    );
  }
}
