import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/hobby/edit_day_dialog.dart';
import 'package:schulplaner/common/functions/get_value_or_null.dart';
import 'package:schulplaner/common/models/hobby.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/widgets/color_choose_list_tile.dart';
import 'package:schulplaner/common/widgets/custom_button.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:uuid/uuid.dart';

class EditHobbyDialog extends HookWidget {
  final Hobby? hobby;

  const EditHobbyDialog({
    super.key,
    this.hobby,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(
      text: hobby?.name,
    );
    final descriptionController = useTextEditingController(
      text: hobby?.description,
    );
    final color = useState<Color>(hobby?.color ?? Colors.blue);
    final moveable = useState<bool>(hobby?.moveable ?? false);
    final days = useState<List<TimeInDay>>(hobby?.days ?? []);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      title: Text("Hobby ${hobby == null ? "hinzufügen" : "bearbeiten"}"),
      icon: const Icon(LucideIcons.tent),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: Spacing.medium),
            CustomTextField(
              controller: nameController,
              labelText: "Name",
              validate: true,
            ),
            const SizedBox(height: Spacing.small),
            CustomTextField(
              controller: descriptionController,
              labelText: "Beschreibung",
              maxLines: 3,
            ),
            const SizedBox(height: Spacing.small),
            ColorChooseListTile(
              color: color.value,
              onColorChanged: (newColor) {
                color.value = newColor;
              },
            ),
            const SizedBox(height: Spacing.small),
            CheckboxListTile(
              title: const Text("Beweglich"),
              value: moveable.value,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radii.small),
              ),
              onChanged: (value) {
                moveable.value = value ?? false;
              },
            ),
            const SizedBox(height: Spacing.small),
            RequiredField(
              errorText: "Es muss mindestens ein Tag angegeben werden.",
              value: days.value,
              child: ListTile(
                title: const Text("Tage"),
                contentPadding: const EdgeInsets.only(
                  left: 16 /* The default left padding */,
                ),
                trailing: SizedBox(
                  width: 200,
                  child: CustomButton(
                    onPressed: () async {
                      final result = await showDialog<TimeInDay>(
                        context: context,
                        builder: (context) => const EditDayDialog(),
                      );

                      if (result != null) {
                        days.value = [...days.value, result];
                      }
                    },
                    child: const Text("Tag hinzufügen"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.small),
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: days.value.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final day = days.value[index];

                  return DisplayDayTile(
                    day: day,
                    onEdit: () async {
                      final day = days.value[index];

                      // Edit the day
                      final result = await showDialog<TimeInDay>(
                        context: context,
                        builder: (context) => EditDayDialog(
                          timeInDay: day,
                        ),
                      );

                      if (result != null) {
                        // Remove the old hobby and add the new hobby at the same index
                        days.value = days.value
                          ..removeAt(index)
                          ..insert(index, result);

                        // Used to update the state
                        days.value = [...days.value];
                      }
                    },
                    onDelete: () {
                      // Delete the day
                      days.value = days.value..removeAt(index);

                      // Used to update the state
                      days.value = [...days.value];
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
            if (!formKey.currentState!.validate()) {
              return;
            }

            Navigator.of(context).pop(
              Hobby(
                name: nameController.text.trim(),
                description: descriptionController.text.getStringOrNull(),
                color: color.value,
                moveable: moveable.value,
                days: days.value,
                uuid: hobby?.uuid ?? const Uuid().v4(),
              ),
            );
          },
          child: Text(hobby == null ? "Hinzufügen" : "Bearbeiten"),
        ),
      ],
    );
  }
}

class DisplayDayTile extends StatelessWidget {
  final TimeInDay day;
  final void Function() onEdit;
  final void Function() onDelete;

  const DisplayDayTile({
    super.key,
    required this.day,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(day),
      direction: DismissDirection.down,
      background: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: const BorderRadius.all(Radii.small),
        ),
        alignment: Alignment.center,
        child: Icon(
          LucideIcons.trash_2,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Padding(
        padding: const EdgeInsets.only(right: Spacing.small),
        child: Material(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.all(Radii.small),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () => onEdit(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.medium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.day.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    day.timeSpan.toFormattedString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
