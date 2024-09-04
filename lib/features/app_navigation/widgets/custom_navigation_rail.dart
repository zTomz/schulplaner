import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';

class CustomNavigationRail extends StatelessWidget {
  /// The selected destination index
  final int selectedIndex;

  /// The callback that is called when a destination is selected
  final void Function(int index) onDestinationSelected;

  /// The list of destinations
  final List<CustomNavigationDestination> destinations;

  /// The callback that is called when the profile button is pressed
  final void Function() onProfilePressed;

  /// Whether the navigation rail is extended
  final bool extended;

  /// The callback that is called when the extended state changes
  final void Function(bool isExtended) onExtendedChanged;

  const CustomNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.onProfilePressed,
    required this.extended,
    required this.onExtendedChanged,
  });

  static const _kRailWidth = 80.0;
  static const _kExtendedRailWidth = 270.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AnimationDurations.normal,
      curve: Curves.decelerate,
      width: extended ? _kExtendedRailWidth : _kRailWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              margin: const EdgeInsets.only(top: Spacing.small),
              child: Center(
                child: IconButton.filled(
                  onPressed: () {
                    onProfilePressed();
                  },
                  iconSize: extended ? 50 : 30,
                  color: Theme.of(context).colorScheme.onPrimary,
                  icon: const Icon(LucideIcons.user_round),
                ),
              ),
            ),
            _buildDestinations(),
            SizedBox(
              height: 80,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    onExtendedChanged(!extended);
                  },
                  tooltip: "Navigationleiste ein-/ausklappen",
                  iconSize: 30,
                  icon: Icon(
                    extended
                        ? LucideIcons.between_horizontal_end
                        : LucideIcons.between_horizontal_start,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Build the destinations.
  Widget _buildDestinations() => Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...destinations.map(
                  (destination) => Padding(
                    padding: EdgeInsets.only(
                      top: Spacing.small,
                      bottom: Spacing.small,
                      left: extended ? Spacing.medium : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: extended
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        if (constraints.maxWidth != _kRailWidth)
                          const SizedBox(width: Spacing.medium),
                        Material(
                          color:
                              selectedIndex == destinations.indexOf(destination)
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: () => onDestinationSelected(
                              destinations.indexOf(destination),
                            ),
                            borderRadius: BorderRadius.circular(360),
                            child: Padding(
                              padding: const EdgeInsets.all(Spacing.small),
                              child: IconTheme(
                                data: IconThemeData(
                                  color: selectedIndex ==
                                          destinations.indexOf(destination)
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                                child: destination.icon,
                              ),
                            ),
                          ),
                        ),
                        if (constraints.maxWidth != _kRailWidth) ...[
                          const SizedBox(width: Spacing.small),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                destination.label,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: selectedIndex ==
                                              destinations.indexOf(destination)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class CustomNavigationDestination {
  final String label;
  final Widget icon;

  const CustomNavigationDestination({
    required this.label,
    required this.icon,
  });
}
