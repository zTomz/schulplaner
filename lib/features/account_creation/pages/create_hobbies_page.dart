import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schulplaner/config/constants/svg_pictures.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/hobby/edit_hobby_dialog.dart';
import 'package:schulplaner/common/functions/get_value_or_null.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/models/hobby.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/gradient_scaffold.dart';
import 'package:schulplaner/common/widgets/hobby_list_tile.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/config/constants/numbers.dart';

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
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showDialog<Hobby>(
                context: context,
                builder: (context) {
                  return const EditHobbyDialog();
                },
              );

              if (result != null) {
                hobbies.value = hobbies.value..add(result);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox.square(
                    dimension: kInfoImageSize,
                    child: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? SvgPictures.no_data_dark
                          : SvgPictures.no_data_light,
                    ),
                  ),
                  const SizedBox(height: Spacing.medium),
                  SizedBox(
                    width: kInfoTextWidth,
                    child: Text(
                      "Sie haben noch keine Hobbies hinzugefügt. Beginnen Sie indem Sie ein  \"Hobby hizufügen\".",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: hobbies.value.length,
              itemBuilder: (context, index) {
                final hobby = hobbies.value[index];

                return HobbyListTile(
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
}
