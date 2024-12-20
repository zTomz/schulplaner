import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class CustomTextField extends HookWidget {
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;
  final bool validate;
  final String? Function(String? value)? validator;
  final AutovalidateMode? autovalidateMode;

  final _CustomTextFieldType _type;

  const CustomTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines = 1,
    this.validate = false,
    this.validator,
    this.autovalidateMode,
  })  : assert(
          validator == null || validate,
          'If a validator is given, than validate has to be true.',
        ),
        _type = _CustomTextFieldType.text;

  const CustomTextField.password({
    super.key,
    this.controller,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.prefixIcon = const Icon(LucideIcons.key_round),
    this.keyboardType,
    this.maxLines = 1,
    this.minLines = 1,
    this.validate = false,
    this.validator,
    this.autovalidateMode,
  })  : assert(
          validator == null || validate,
          'If a validator is given, than validate has to be true.',
        ),
        _type = _CustomTextFieldType.password;

  const CustomTextField.email({
    super.key,
    this.controller,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.prefixIcon = const Icon(LucideIcons.mail),
    this.keyboardType,
    this.maxLines = 1,
    this.minLines = 1,
    this.validate = false,
    this.validator,
    this.autovalidateMode,
  })  : assert(
          validator == null || validate,
          'If a validator is given, than validate has to be true.',
        ),
        _type = _CustomTextFieldType.email;

  @override
  Widget build(BuildContext context) {
    final showPassword = useState<bool>(false);
    final isNotEmpty = controller != null
        ? useListenable(controller!).text.trim().isNotEmpty
        : false;

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: _getKeyboardType(),
      scribbleEnabled: true,
      // Check if validate is enabled. If it is check if the validator is not null
      // if it is not null, than use it, else use the preconfigured validator
      validator: _getValidator(),
      autovalidateMode: autovalidateMode,
      minLines: minLines,
      maxLines: maxLines,
      obscureText:
          !showPassword.value && _type == _CustomTextFieldType.password,
      decoration: InputDecoration(
        labelText: labelText,
        alignLabelWithHint: true,
        hintText: hintText,
        helper: (validate != false || validator != null) && !isNotEmpty
            ? Text(
                "Dieses Feld ist erforderlich.",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
              )
            : null,
        prefixIcon: prefixIcon,
        suffix: _type == _CustomTextFieldType.password
            ? ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 28, maxWidth: 28),
                child: IconButton(
                  onPressed: () {
                    showPassword.value = !showPassword.value;
                  },
                  tooltip:
                      "Passwort ${showPassword.value ? "verbergen" : "anzeigen"}",
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    showPassword.value ? LucideIcons.eye_off : LucideIcons.eye,
                    size: 18.0,
                  ),
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

  TextInputType? _getKeyboardType() {
    if (keyboardType != null) {
      return keyboardType;
    }

    switch (_type) {
      case _CustomTextFieldType.email:
        return TextInputType.emailAddress;
      case _CustomTextFieldType.password:
        return TextInputType.visiblePassword;
      case _CustomTextFieldType.text:
        return TextInputType.text;
    }
  }

  String? Function(String? value)? _getValidator() {
    if (validate == false) {
      return null;
    }

    if (validator != null) {
      return validator;
    }

    switch (_type) {
      case _CustomTextFieldType.email:
        return (value) {
          if (value == null || !EmailValidator.validate(value)) {
            return "Bitte geben Sie eine gültige E-Mail-Adresse ein.";
          }

          return null;
        };
      case _CustomTextFieldType.password:
        return (value) {
          if (value == null ||
              value.trim().isEmpty ||
              value.trim().length < 8) {
            return "Das Passwort muss mindestens 8 Zeichen lang sein.";
          }

          return null;
        };
      case _CustomTextFieldType.text:
        return (value) {
          if (value == null || value.trim().isEmpty) {
            return "Dieses Feld ist erforderlich.";
          }

          return null;
        };
    }
  }
}

enum _CustomTextFieldType { text, email, password }
