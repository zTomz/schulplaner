import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class RequiredField<T> extends FormField {
  final Widget child;
  final String errorText;
  final T? value;
  final BorderRadiusGeometry? borderRadius;

  RequiredField({
    super.key,
    required this.errorText,
    required this.value,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radii.small),
  }) : super(
          validator: (_) {
            if (value == null) {
              return errorText;
            }

            // Handle lists, which are empty, but not [null]
            if (value is List && (value as List).isEmpty) {
              return errorText;
            }

            // Handle sets, which are empty, but not [null]
            if (value is Set && (value as Set).isEmpty) {
              return errorText;
            }

            return null;
          },
          builder: (state) {
            if (state.hasError) {
              return Builder(
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.error,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                      child: child,
                    ),
                    Padding(
                      // The values for the supportive text on a text form field Material 3
                      padding: const EdgeInsets.only(top: 4.0, left: 16.0),
                      child: Text(
                        errorText,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    )
                  ],
                ),
              );
            }

            return child;
          },
        );
}
