import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/config/constants/svg_pictures.dart';

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


class NoDataWidget extends StatelessWidget {
  final Widget? addDataButton;

  const NoDataWidget({
    super.key,
    this.addDataButton,
  });

  @override
  Widget build(BuildContext context) {
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
              "Noch keine Daten hinzugefügt.",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          if (addDataButton != null) ...[
            const SizedBox(height: Spacing.large),
            addDataButton!,
          ],
        ],
      ),
    );
  }
}
