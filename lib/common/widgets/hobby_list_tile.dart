
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/models/hobby.dart';

class HobbyListTile extends StatelessWidget {
  final Hobby hobby;
  final void Function() onEdit;
  final void Function() onDelete;

  const HobbyListTile({
    super.key,
    required this.hobby,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.small,
        horizontal: Spacing.medium,
      ),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radii.small),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 80,
          child: InkWell(
            onTap: () => onEdit(),
            child: Row(
              children: [
                Container(
                  width: 15,
                  color: hobby.color,
                ),
                const SizedBox(width: Spacing.large),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hobby.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (hobby.description != null)
                      Text(
                        hobby.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
                const Spacer(),
                Tooltip(
                  message: "Hobby bearbeiten",
                  child: Icon(
                    LucideIcons.pencil,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: Spacing.small),
                IconButton(
                  onPressed: () => onDelete(),
                  tooltip: "Hobby löschen",
                  color: Theme.of(context).colorScheme.onSurface,
                  icon: const Icon(LucideIcons.trash_2),
                ),
                const SizedBox(width: Spacing.large),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
