import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';

class SelectionRow extends StatelessWidget {
  final Widget title;
  final Widget? content;
  final void Function() onPressed;

  const SelectionRow({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 70,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyLarge!,
            textAlign: TextAlign.left,
            child: title,
          ),
        ),
        const SizedBox(width: Spacing.medium),
        Material(
          borderRadius: const BorderRadius.all(Radii.small),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radii.small),
            onTap: onPressed,
            child: SizedBox(
              width: 120,
              height: 35,
              child: content != null
                  ? Center(
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodyLarge!,
                        overflow: TextOverflow.fade,
                        child: content!,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
