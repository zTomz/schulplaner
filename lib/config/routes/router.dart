import 'package:auto_route/auto_route.dart';
import 'package:schulplaner/config/routes/auth_route_guards.dart';
import 'package:schulplaner/config/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Intro pages
        AutoRoute(
          page: IntroRoute.page,
          keepHistory: false,
          guards: [SignedInCheckGuard()],
        ),
        CustomRoute(
          page: ConfigureWeeklyScheduleRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 400,
          keepHistory: false,
          guards: [SignedInCheckGuard()],
        ),
        CustomRoute(
          page: ConfigureHobbyRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 400,
          keepHistory: false,
          guards: [SignedInCheckGuard()],
        ),
        CustomRoute(
          page: SignUpSignInRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 400,
          keepHistory: false,
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
          ],
        ),
      ];
}
