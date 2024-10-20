import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/models/hobby.dart';

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
    return Align(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.small,
            horizontal: Spacing.medium,
          ),
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainer,
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
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hobby.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          hobby.description != null
                              ? Text(
                                  hobby.description!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              : SizedBox(
                                  height: 30,
                                  child: ListView.builder(
                                    itemCount: hobby.days.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final currentDay = hobby.days[index];

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: Spacing.medium,
                                        ),
                                        margin: const EdgeInsets.only(
                                          right: Spacing.small,
                                        ),
                                        decoration: BoxDecoration(
                                          color: hobby.color.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(360),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${currentDay.day.name.substring(0, 2)}. ${currentDay.timeSpan.toFormattedString()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: hobby.color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Spacing.medium),
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
        ),
      ),
    );
  }
}
