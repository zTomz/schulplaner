import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class RequiredField<T> extends FormField {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;

  RequiredField({
    super.key,
    required String errorText,
    required T value,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radii.small),
  }) : super(
          validator: (_) {
            if (_checkValue(value)) {
              return errorText;
            }

            return null;
          },
          builder: (state) => _customBuilder(
            state,
            borderRadius: borderRadius!,
            child: child,
          ),
        );

  /// Check for multiple values. The number of error texts must match the number of
  /// values.
  RequiredField.multiple({
    super.key,
    required List<String> errorTexts,
    required List<T> values,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radii.small),
  })  : assert(errorTexts.length == values.length,
            "There must be as many error texts as values."),
        super(
          validator: (_) {
            for (var i = 0; i < values.length; i++) {
              if (_checkValue(values[i])) {
                return errorTexts[i];
              }
            }

            return null;
          },
          builder: (state) => _customBuilder(
            state,
            borderRadius: borderRadius!,
            child: child,
          ),
        );

  /// Check if the provided value is null or an empty array or something.
  /// If it is, than return true, else false
  static bool _checkValue(dynamic value) {
    if (value == null) {
      return true;
    }

    // Handle lists, which are empty, but not [null]
    if (value is List && (value).isEmpty) {
      return true;
    }

    // Handle sets, which are empty, but not [null]
    if (value is Set && (value).isEmpty) {
      return true;
    }

    return false;
  }

  static Widget _customBuilder(
    FormFieldState<dynamic> state, {
    required BorderRadiusGeometry borderRadius,
    required Widget child,
  }) {
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
                state.errorText ?? "Unbekannter Fehler.",
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
  }
}
