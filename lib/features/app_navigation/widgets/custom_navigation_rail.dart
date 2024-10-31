import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';

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
        color: Theme.of(context).colorScheme.surfaceContainerLow,
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
                  tooltip: "Profil",
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                  (destination) => _CustomNavigaitonRailDestination(
                    destination: destination,
                    isSelected: selectedIndex ==
                        destinations.indexOf(
                          destination,
                        ),
                    isExpanded: constraints.maxWidth != _kRailWidth,
                    onDestinationSelected: () => onDestinationSelected(
                      destinations.indexOf(destination),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

/// The destination for the [CustomNavigationRail].
class _CustomNavigaitonRailDestination extends HookWidget {
  /// The destination
  final CustomNavigationDestination destination;

  /// A bool that indicates if the [CustomNavigationDestination] is selected
  final bool isSelected;

  /// A bool that indicates if the [CustomNavigationRail] is expanded
  final bool isExpanded;

  /// A function that is called, when a destination is selected
  final void Function() onDestinationSelected;

  const _CustomNavigaitonRailDestination({
    required this.destination,
    required this.isSelected,
    required this.isExpanded,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isHovering = useState<bool>(false);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Spacing.small,
        horizontal: isExpanded ? Spacing.medium : 0,
      ),
      child: Container(
        width: isExpanded ? double.infinity : 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
        ),
        clipBehavior: Clip.hardEdge,
        child: MouseRegion(
          onEnter: (_) {
            isHovering.value = true;
          },
          onExit: (_) {
            isHovering.value = false;
          },
          child: InkWell(
            onTap: isExpanded ? () => onDestinationSelected() : null,
            child: Row(
              mainAxisAlignment: isExpanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: destination.label,
                  child: Material(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => onDestinationSelected(),
                      borderRadius: BorderRadius.circular(360),
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.small),
                        child: IconTheme(
                          data: IconThemeData(
                            color: isSelected || isHovering.value
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          child: destination.icon,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(width: Spacing.small),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        destination.label,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: isSelected || isHovering.value
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomNavigationDestination {
  final String label;
  final Widget icon;

  const CustomNavigationDestination({
    required this.label,
    required this.icon,
  });
}
