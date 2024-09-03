import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';

class CustomButton extends StatelessWidget {
  final Text child;
  final String? selection;
  final void Function() onPressed;

  final _CustomButtonType _type;

  const CustomButton({
    super.key,
    required this.child,
    this.selection,
    required this.onPressed,
  }) : _type = _CustomButtonType.normal;

  const CustomButton.tonal({
    super.key,
    required this.child,
    this.selection,
    required this.onPressed,
  }) : _type = _CustomButtonType.tonal;

  const CustomButton.selection({
    super.key,
    required this.child,
    required this.selection,
    required this.onPressed,
  }) : _type = _CustomButtonType.selection;

  @override
  Widget build(BuildContext context) {
    if (_type == _CustomButtonType.tonal) {
      return FilledButton.tonal(
        onPressed: () => onPressed(),
        style: _buttonStyle(),
        child: _buildChild(),
      );
    }

    return FilledButton(
      onPressed: () => onPressed(),
      style: _buttonStyle(),
      child: _buildChild(),
    );
  }

  ButtonStyle _buttonStyle() => FilledButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radii.small,
          ),
        ),
      );

  Widget _buildChild() => SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: _type == _CustomButtonType.selection
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Builder(builder: (context) {
              return DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.surface),
                child: child,
              );
            }),
            if (_type == _CustomButtonType.selection) ...[
              const Spacer(),
              if (selection != null) ...[
                Text(selection!),
                const SizedBox(width: Spacing.medium),
              ],
              const Icon(LucideIcons.chevron_right),
            ]
          ],
        ),
      );
}

enum _CustomButtonType { normal, tonal, selection }
