
import 'package:flutter/material.dart';
import 'package:schulplaner/config/theme/numbers.dart';

class RequiredField extends StatelessWidget {
  final Widget child;
  final String? error;

  const RequiredField({
    super.key,
    required this.child,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radii.small),
            border: Border.all(
                color: error != null
                    ? Theme.of(context).colorScheme.error
                    : Colors.transparent,
                strokeAlign: BorderSide.strokeAlignInside),
          ),
          child: child,
        ),
        if (error != null)
          Padding(
            // The values for the supportive text on a text form field Material 3
            padding: const EdgeInsets.only(top: 4.0, left: 16.0),
            child: Text(
              error!,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          )
      ],
    );
  }
}
