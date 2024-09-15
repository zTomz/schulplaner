import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/hobby/edit_hobby_dialog.dart';
import 'package:schulplaner/common/functions/get_value_or_null.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/models/weekly_schedule_data.dart';
import 'package:schulplaner/common/models/hobby.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/common/constants/numbers.dart';

class CreateHobbiesPage extends HookWidget {
  /// The weekly schedule if created from the [create_weekly_schedule_page.dart]
  final WeeklyScheduleData? weeklyScheduleData;

  /// The teachers if created from the [create_weekly_schedule_page.dart]
  final List<Teacher>? teachers;

  /// The subjects if created from the [create_weekly_schedule_page.dart]
  final List<Subject>? subjects;

  const CreateHobbiesPage({
    super.key,
    this.weeklyScheduleData,
    this.teachers,
    this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    final hobbies = useState<List<Hobby>>([]);

    return GradientScaffold(
      appBar: CustomAppBar(
        title: const Text(
          "Hobbies hinzufügen",
        ),
        actions: [
          if (hobbies.value.isNotEmpty)
            _addHobbyButton(
              context,
              onHobbyAdded: (hobby) {
                hobbies.value = [...hobbies.value, hobby];
              },
            ),
          const SizedBox(width: Spacing.medium),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          await context.router.push(
            SignUpSignInRoute(
              weeklyScheduleData: weeklyScheduleData,
              hobbies: hobbies.value.getListOrNull() as List<Hobby>?,
              teachers: teachers,
              subjects: subjects,
            ),
          );
        },
        tooltip: "Weiter",
        child: const Icon(LucideIcons.arrow_right),
      ),
      body: hobbies.value.isEmpty
          ? Center(
              child: _addHobbyButton(
                context,
                onHobbyAdded: (hobby) {
                  hobbies.value = [...hobbies.value, hobby];
                },
              ),
            )
          : ListView.builder(
              itemCount: hobbies.value.length,
              itemBuilder: (context, index) {
                final hobby = hobbies.value[index];

                return DisplayHobbyTile(
                  hobby: hobby,
                  onEdit: () async {
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
                  onDelete: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => CustomDialog.confirmation(
                        description:
                            "Sind Sie sich sicher, dass Sie das Hobby \"${hobby.name}\" löschen möchten.",
                      ),
                    );

                    if (result == true) {
                      //  Delete the hobby
                      hobbies.value.removeAt(index);

                      hobbies.value = [...hobbies.value];
                    }
                  },
                );
              },
            ),
    );
  }

  Widget _addHobbyButton(
    BuildContext context, {
    required void Function(Hobby hobby) onHobbyAdded,
  }) {
    return ElevatedButton.icon(
      onPressed: () async {
        final result = await showDialog<Hobby>(
          context: context,
          builder: (context) {
            return const EditHobbyDialog();
          },
        );

        if (result != null) {
          onHobbyAdded(result);
        }
      },
      icon: const Icon(
        LucideIcons.circle_plus,
        size: 20,
      ),
      label: const Text("Hobby hinzufügen"),
    );
  }
}

class DisplayHobbyTile extends StatelessWidget {
  final Hobby hobby;
  final void Function() onEdit;
  final void Function() onDelete;

  const DisplayHobbyTile({
    super.key,
    required this.hobby,
    required this.onEdit,
    required this.onDelete,
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
                Tooltip(
                  message: "Hobby bearbeiten",
                  child: Icon(
                    LucideIcons.pencil,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: Spacing.small),
                IconButton(
                  onPressed: () => onDelete(),
                  tooltip: "Hobby löschen",
                  color: Theme.of(context).colorScheme.onSurface,
                  icon: const Icon(LucideIcons.trash_2),
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
