import 'package:flutter/material.dart';
import 'package:schulplaner/common/constants/numbers.dart';

class DataLoadingWidget extends StatelessWidget {
  const DataLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}

class DataErrorWidget extends StatelessWidget {
  const DataErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}