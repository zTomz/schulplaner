import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/shared/dialogs/custom_dialog.dart';
import 'package:schulplaner/shared/extensions/date_time_extension.dart';
import 'package:schulplaner/shared/functions/get_value_or_null.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/widgets/color_choose_list_tile.dart';
import 'package:schulplaner/shared/widgets/custom_button.dart';
import 'package:schulplaner/shared/widgets/custom_text_field.dart';
import 'package:schulplaner/shared/widgets/required_field.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:uuid/uuid.dart';

class EditReminderEventDialog extends HookWidget {
  final ReminderEvent? reminderEvent;
  final void Function()? onReminderEventDeleted;

  const EditReminderEventDialog({
    super.key,
    this.reminderEvent,
    this.onReminderEventDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final date = useState<DateTime?>(reminderEvent?.date);
    final nameController = useTextEditingController(
      text: reminderEvent?.name,
    );
    final descriptionController = useTextEditingController(
      text: reminderEvent?.description,
    );
    final locationController = useTextEditingController(
      text: reminderEvent?.place,
    );
    final color = useState<Color>(reminderEvent?.color ?? Colors.blue);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      icon: const Icon(LucideIcons.bell),
      title: Text(
          "Erinnerung ${reminderEvent == null ? "erstellen" : "bearbeiten"}"),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              labelText: "Name",
              validate: true,
            ),
            const SizedBox(height: Spacing.small),
            RequiredField(
              errorText: "Ein Datum ist erforderlich.",
              value: date.value,
              child: CustomButton.selection(
                selection: date.value?.formattedDate,
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
                child: const Text("Datum"),
              ),
            ),
            const SizedBox(height: Spacing.small),
            ColorChooseListTile(
              color: color.value,
              onColorChanged: (newColor) {
                color.value = newColor;
              },
            ),
            const SizedBox(height: Spacing.small),
            CustomTextField(
              controller: locationController,
              labelText: "Ort",
              prefixIcon: const Icon(LucideIcons.map_pin),
            ),
            const SizedBox(height: Spacing.small),
            CustomTextField(
              controller: descriptionController,
              labelText: "Beschreibung",
              maxLines: 3,
              minLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        if (reminderEvent != null && onReminderEventDeleted != null) ...[
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => CustomDialog.confirmation(
                  title: "Erinnerung löschen",
                  description:
                      "Sind Sie sich sicher, dass Sie diese Erinnerung löschen möchten?",
                ),
              );

              if (result != null && context.mounted) {
                onReminderEventDeleted?.call();
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            icon: const Icon(LucideIcons.trash_2),
            label: const Text("Erinnerung löschen"),
          ),
          const Spacer(),
        ],
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

            Navigator.of(context).pop(
              ReminderEvent(
                name: nameController.text,
                description: descriptionController.text.getStringOrNull(),
                place: locationController.text.getStringOrNull(),
                date: date.value!,
                color: color.value,
                uuid: reminderEvent?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: Text(reminderEvent == null ? "Erstellen" : "Bearbeiten"),
        ),
      ],
    );
  }
}
