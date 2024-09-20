import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/custom_dialog.dart';
import 'package:schulplaner/common/dialogs/hobby/edit_hobby_dialog.dart';
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
          // TODO: Add error handling or when no data is available
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text("Error"),
            );
          }

          final List<Hobby> hobbies = snapshot.data!.docs
              .map((doc) => Hobby.fromMap(doc.data()))
              .toList();

          return ListView.builder(
            itemCount: hobbies.length,
            itemBuilder: (context, index) {
              final currentHobby = hobbies[index];

              return HobbyListTile(
                hobby: currentHobby,
                onEdit: () async {
                  print("Edit");
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
