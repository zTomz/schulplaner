import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/config/routes/router.gr.dart';

@RoutePage()
class AppNavigationPage extends HookWidget {
  const AppNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationRailIsExtended = useState<bool>(false);

    return AutoTabsRouter(
      routes: const [
        OverviewRoute(),
        WeeklyScheduleRoute(),
        CalendarRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        // the passed child is technically our animated selected-tab page
        child: child,
      ),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: Row(
            children: [
              CustomNavigationRail(
                selectedIndex: tabsRouter.activeIndex,
                onDestinationSelected: tabsRouter.setActiveIndex,
                onExtendedChanged: (isExtended) {
                  navigationRailIsExtended.value = isExtended;
                },
                extended: navigationRailIsExtended.value,
                destinations: const [
                  CustomNavigationDestination(
                    label: "Übersicht",
                    icon: Icon(LucideIcons.panels_top_left),
                  ),
                  CustomNavigationDestination(
                    label: "Stundenplan",
                    icon: Icon(LucideIcons.notebook_tabs),
                  ),
                  CustomNavigationDestination(
                    label: "Kalender",
                    icon: Icon(LucideIcons.calendar),
                  ),
                ],
              ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final void Function(int index) onDestinationSelected;
  final List<CustomNavigationDestination> destinations;

  final void Function(bool isExtended) onExtendedChanged;
  final bool extended;

  const CustomNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.extended,
    required this.onExtendedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AnimationDurations.normal,
      width: extended ? 270 : 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            margin: const EdgeInsets.only(top: Spacing.large),
            child: Center(
              child: IconButton.filled(
                onPressed: () {
                  // TODO: Go to profile page
                },
                iconSize: extended ? 50 : 30,
                icon: const Icon(LucideIcons.user_round),
              ),
            ),
          ),
          const Spacer(),
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
                  Material(
                    color: selectedIndex == destinations.indexOf(destination)
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
                  if (extended) ...[
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
          const Spacer(),
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
