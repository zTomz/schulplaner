import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/edit_time_span_dialog.dart';
import 'package:schulplaner/common/functions/build_body_part.dart';
import 'package:schulplaner/common/models/hobby.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/widgets/color_choose_list_tile.dart';
import 'package:schulplaner/common/widgets/custom_text_field.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/common/widgets/required_field.dart';
import 'package:schulplaner/common/widgets/selection_button.dart';
import 'package:schulplaner/config/theme/numbers.dart';
import 'package:schulplaner/config/theme/text_styles.dart';
import 'package:uuid/uuid.dart';

class CreateHobbiesPage extends HookWidget {
  const CreateHobbiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hobbies = useState<List<Hobby>>([]);

    return GradientScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Hobbies hinzufügen",
          style: TextStyles.title,
        ),
        toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<Hobby>(
                context: context,
                builder: (context) {
                  return const EditHobbyDialog();
                },
              );

              if (result != null) {
                hobbies.value = [...hobbies.value, result];
              }
            },
            icon: const Icon(
              LucideIcons.circle_plus,
              size: 20,
            ),
            label: const Text("Hobby hinzufügen"),
          ),
          const SizedBox(width: Spacing.medium),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          // TODO: Go to the next page
        },
        tooltip: "Weiter",
        child: const Icon(LucideIcons.arrow_right),
      ),
      body: ListView.builder(
        itemCount: hobbies.value.length,
        itemBuilder: (context, index) {
          final hobby = hobbies.value[index];

          return DisplayHobbyTile(
            hobby: hobby,
            onEdit: () async {
              // TODO: Edit hobby
              final result = await showDialog<Hobby>(
                context: context,
                builder: (context) {
                  return EditHobbyDialog(
                    hobby: hobby,
                  );
                },
              );

              if (result != null) {
                // Remove the old hobby and replace it
                hobbies.value = hobbies.value
                  ..removeAt(index)
                  ..insert(index, result);

                // Update the state
                hobbies.value = [...hobbies.value];
              }
            },
          );
        },
      ),
    );
  }
}

class DisplayHobbyTile extends StatelessWidget {
  final Hobby hobby;
  final void Function() onEdit;

  const DisplayHobbyTile({
    super.key,
    required this.hobby,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.small,
        horizontal: Spacing.medium,
      ),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radii.small),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 80,
          child: InkWell(
            onTap: () => onEdit(),
            child: Row(
              children: [
                Container(
                  width: 15,
                  color: hobby.color,
                ),
                const SizedBox(width: Spacing.large),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hobby.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (hobby.description != null)
                      Text(
                        hobby.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
                const Spacer(),
                const Tooltip(
                  message: "Hobby bearbeiten",
                  child: Icon(LucideIcons.pencil),
                ),
                const SizedBox(width: Spacing.large),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
      icon: const Icon(LucideIcons.tent_tree),
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
                  child: SelectionButton(
                    title: "Tag hinzufügen",
                    selection: null,
                    onPressed: () async {
                      final result = await showDialog<TimeInDay>(
                        context: context,
                        builder: (context) => const EditDayDialog(),
                      );

                      if (result != null) {
                        days.value = [...days.value, result];
                      }
                    },
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

            final description = descriptionController.text.trim();

            Navigator.of(context).pop(
              Hobby(
                name: nameController.text.trim(),
                description: description.isEmpty ? null : description,
                color: color.value,
                moveable: moveable.value,
                days: days.value,
                uuid: const Uuid().v4(),
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
        child: const Icon(LucideIcons.trash_2),
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

class EditDayDialog extends HookWidget {
  final TimeInDay? timeInDay;

  const EditDayDialog({
    super.key,
    this.timeInDay,
  });

  @override
  Widget build(BuildContext context) {
    final weekday = useState<Weekday?>(timeInDay?.day);
    final timeSpan = useState<TimeSpan?>(timeInDay?.timeSpan);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return CustomDialog.expanded(
      title: Text("Tag ${timeInDay == null ? "hinzufügen" : "bearbeiten"}"),
      icon: const Icon(LucideIcons.calendar),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RequiredField(
              errorText: "Ein Wochentag ist erforderlich.",
              value: weekday.value,
              child: buildBodyPart(
                context,
                title: "Wochentag",
                child: SegmentedButton<Weekday?>(
                  segments: Weekday.values
                      .map(
                        (day) => ButtonSegment(
                          value: day,
                          tooltip: day.name,
                          label: Text(
                            day.name.substring(0, 1),
                          ),
                        ),
                      )
                      .toList(),
                  selected: {weekday.value},
                  onSelectionChanged: (value) {
                    weekday.value = value.first;
                  },
                ),
              ),
            ),
            const SizedBox(height: Spacing.small),
            RequiredField(
              errorText: "Eine Zeitspanne ist erforderlich.",
              value: timeSpan.value,
              child: SelectionButton(
                title: "Zeitspanne",
                selection: timeSpan.value?.toFormattedString(),
                onPressed: () async {
                  final result = await showDialog<TimeSpan>(
                    context: context,
                    builder: (context) => EditTimeSpanDialog(
                      timeSpan: timeSpan.value,
                    ),
                  );

                  if (result != null) {
                    timeSpan.value = result;
                  }
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
          child: const Text("Abbrechen"),
        ),
        const SizedBox(width: Spacing.small),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }

            Navigator.of(context).pop<TimeInDay>(
              TimeInDay(
                day: weekday.value!,
                timeSpan: timeSpan.value!,
              ),
            );
          },
          child: Text(timeInDay == null ? "Hinzufügen" : "Bearbeiten"),
        ),
      ],
    );
  }
}
