import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/constants/svg_pictures.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/hobby/edit_hobby_dialog.dart';
import 'package:schulplaner/common/functions/handle_snapshot_state.dart';
import 'package:schulplaner/common/models/hobby.dart';
import 'package:schulplaner/common/services/database_service.dart';
import 'package:schulplaner/common/widgets/custom_app_bar.dart';
import 'package:schulplaner/common/widgets/hobby_list_tile.dart';

@RoutePage()
class HobbiesPage extends StatelessWidget {
  const HobbiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text(
          "Hobbies",
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

              if (result != null && context.mounted) {
                await DatabaseService.uploadHobbies(
                  context,
                  hobbies: [result],
                );
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
      body: StreamBuilder(
        stream: DatabaseService.hobbiesCollection.snapshots(),
        builder: (context, snapshot) {
          final snapshotState = handleSnapshotState(
            context,
            snapshot: snapshot,
          );

          if (snapshotState != null) {
            return snapshotState;
          }

          final List<Hobby> hobbies = snapshot.data!.docs
              .map((doc) => Hobby.fromMap(doc.data()))
              .toList();

          if (hobbies.isEmpty) {
            return Center(
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
                      "Sie haben noch keine Hobbies hinzugefügt. Beginnen Sie indem Sie ein \"Hobby hizufügen\".",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: hobbies.length,
            itemBuilder: (context, index) {
              final currentHobby = hobbies[index];

              return HobbyListTile(
                hobby: currentHobby,
                onEdit: () async {
                  final result = await showDialog<Hobby>(
                    context: context,
                    builder: (context) {
                      return EditHobbyDialog(
                        hobby: currentHobby,
                      );
                    },
                  );

                  if (result != null && context.mounted) {
                    await DatabaseService.uploadHobbies(
                      context,
                      hobbies: [result],
                    );
                  }
                },
                onDelete: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => CustomDialog.confirmation(
                      description:
                          "Sind Sie sich sicher, dass Sie das Hobby \"${currentHobby.name}\" löschen möchten.",
                    ),
                  );

                  if (result == true && context.mounted) {
                    await DatabaseService.deleteHobbies(
                      context,
                      hobbies: [currentHobby],
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
