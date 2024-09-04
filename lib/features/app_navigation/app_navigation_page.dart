import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/routes/router.gr.dart';
import 'package:schulplaner/features/app_navigation/widgets/custom_navigation_rail.dart';

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
                onProfilePressed: () {
                  // TODO: Go to profile page
                },
                extended: navigationRailIsExtended.value,
                onExtendedChanged: (isExtended) {
                  navigationRailIsExtended.value = isExtended;
                },
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
