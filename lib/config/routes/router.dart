import 'package:auto_route/auto_route.dart';
import 'package:schulplaner/config/routes/auth_route_guards.dart';
import 'package:schulplaner/config/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Intro pages
        CustomRoute(
          page: AuthenticationRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 400,
          keepHistory: false,
          guards: [SignedInCheckGuard()],
        ),

        // App pages
        AutoRoute(
          page: AppNavigationRoute.page,
          initial: true,
          guards: [AuthGuard()],
          children: [
            AutoRoute(
              page: OverviewRoute.page,
              initial: true,
              guards: [AuthGuard()],
            ),
            AutoRoute(
              page: CalendarRoute.page,
              guards: [AuthGuard()],
            ),
            AutoRoute(
              page: WeeklyScheduleRoute.page,
              guards: [AuthGuard()],
            ),
            AutoRoute(
              page: HobbiesRoute.page,
              guards: [AuthGuard()],
            ),
          ],
        ),
      ];
}
