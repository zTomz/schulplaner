import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/extensions/date_time_extension.dart';
import 'package:schulplaner/common/functions/get_value_or_null.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/widgets/color_choose_list_tile.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:uuid/uuid.dart';

class EditFixedEventDialog extends HookWidget {
  final FixedEvent? fixedEvent;
  final void Function()? onFixedEventDeleted;

  const EditFixedEventDialog({
    super.key,
    this.fixedEvent,
    this.onFixedEventDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final date = useState<DateTime?>(fixedEvent?.date);
    final nameController = useTextEditingController(
      text: fixedEvent?.name,
    );
    final descriptionController = useTextEditingController(
      text: fixedEvent?.description,
    );
    final locationController = useTextEditingController(
      text: fixedEvent?.place,
    );
    final color = useState<Color>(fixedEvent?.color ?? Colors.blue);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      icon: const Icon(LucideIcons.bell),
      title:
          Text("Erinnerung ${fixedEvent == null ? "erstellen" : "bearbeiten"}"),
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
        if (fixedEvent != null && onFixedEventDeleted != null) ...[
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
                onFixedEventDeleted?.call();
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
              FixedEvent(
                name: nameController.text,
                description: descriptionController.text.getStringOrNull(),
                place: locationController.text.getStringOrNull(),
                date: date.value!,
                color: color.value,
                uuid: fixedEvent?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: Text(fixedEvent == null ? "Erstellen" : "Bearbeiten"),
        ),
      ],
    );
  }
}
