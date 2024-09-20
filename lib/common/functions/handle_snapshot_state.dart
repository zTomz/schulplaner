import 'package:flutter/material.dart';
import 'package:schulplaner/common/constants/numbers.dart';

/// Returns a widget with helpful information if [snapshot] has an error or no data. If 
/// everything is okay, returns null.
Widget? handleSnapshotState(
  BuildContext context, {
  required AsyncSnapshot snapshot,
}) {
  if (snapshot.hasError) {
    return Center(
      child: SizedBox(
        width: kInfoTextWidth,
        child: Text(
          "Leider ist ein Fehler aufgetreten und die Daten konnten nicht geladen werden.",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  if (!snapshot.hasData) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: Spacing.large),
          SizedBox(
            width: kInfoTextWidth,
            child: Text(
              "Daten werden geladen. Bitte haben Sie einem Moment Geduld.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  return null;
}
