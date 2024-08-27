import 'package:flutter/material.dart';
import 'package:schulplaner/config/theme/numbers.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool validate;
  final String? Function(String? value)? validator;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.keyboardType,
    this.validate = false,
    this.validator,
  }) : assert(
          validator == null || validate,
          'If a validator is given, than validate has to be true.',
        );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      // Check if validate is enabled. If it is check if the validator is not null
      // if it is not null, than use it, else use the preconfigured validator
      validator: validate == false
          ? null
          : validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Dieses Feld ist erforderlich';
                }
                return null;
              },
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radii.small,
          ),
        ),
      ),
    );
  }
}
