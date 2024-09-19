import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/common/constants/numbers.dart';
import 'package:schulplaner/common/dialogs/account_dialog.dart';
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
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
            type: ExpandableFabType.up,
            distance: 75,
            overlayStyle: ExpandableFabOverlayStyle(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              blur: 1,
            ),
            openButtonBuilder: RotateFloatingActionButtonBuilder(
              child: const Icon(LucideIcons.plus),
              fabSize: ExpandableFabSize.large,
            ),
            closeButtonBuilder: RotateFloatingActionButtonBuilder(
              child: const Icon(LucideIcons.x),
              fabSize: ExpandableFabSize.regular,
            ),
            children: [
              _buildFabOption(
                title: "Hausaufgabe",
                icon: const Icon(LucideIcons.book_open_text),
                onPressed: () {
                  // TODO: Add a homework here
                },
              ),
              _buildFabOption(
                title: "Arbeit",
                icon: const Icon(LucideIcons.briefcase_business),
                onPressed: () {
                  // TODO: Add a test here
                },
              ),
              _buildFabOption(
                title: "Erinnerung",
                icon: const Icon(LucideIcons.bell),
                onPressed: () {
                  // TODO: Add a reminder here
                },
              ),
            ],
          ),
          body: Row(
            children: [
              CustomNavigationRail(
                selectedIndex: tabsRouter.activeIndex,
                onDestinationSelected: tabsRouter.setActiveIndex,
                onProfilePressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AccountDialog(),
                  );
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

  Widget _buildFabOption({
    required String title,
    required Icon icon,
    required void Function()? onPressed,
  }) {
    return Builder(
      builder: (context) {
        return Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: Spacing.medium),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: onPressed,
              child: icon,
            ),
          ],
        );
      },
    );
  }
}
