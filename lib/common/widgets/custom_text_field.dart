import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';

class CustomTextField extends HookWidget {
  final TextEditingController? controller;
  final String? labelText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool validate;
  final String? Function(String? value)? validator;

  final _CustomTextFieldType _type;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.validate = false,
    this.validator,
  })  : assert(
          validator == null || validate,
          'If a validator is given, than validate has to be true.',
        ),
        _type = _CustomTextFieldType.text;

  const CustomTextField.password({
    super.key,
    this.controller,
    this.labelText,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.validate = false,
    this.validator,
  })  : assert(
          validator == null || validate,
          'If a validator is given, than validate has to be true.',
        ),
        _type = _CustomTextFieldType.password;

  @override
  Widget build(BuildContext context) {
    final showPassword = useState<bool>(false);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      // Check if validate is enabled. If it is check if the validator is not null
      // if it is not null, than use it, else use the preconfigured validator
      validator: validate == false
          ? null
          : validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Dieses Feld ist erforderlich.";
                }
                return null;
              },
      minLines: 1,
      maxLines: maxLines,
      obscureText:
          !showPassword.value && _type == _CustomTextFieldType.password,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffix: _type == _CustomTextFieldType.password
            ? ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 28, maxWidth: 28),
                child: IconButton(
                  onPressed: () {
                    showPassword.value = !showPassword.value;
                  },
                  padding: EdgeInsets.zero,
                  icon: Icon(
                      showPassword.value
                          ? LucideIcons.eye_off
                          : LucideIcons.eye,
                      size: 18.0),
                ),
              )
            : null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radii.small,
          ),
        ),
      ),
    );
  }
}

enum _CustomTextFieldType { password, text }
