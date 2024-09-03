import 'package:auto_route/auto_route.dart';
import 'package:schulplaner/config/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Intro pages
        AutoRoute(
          page: IntroRoute.page,
          initial: true,
        ),
        CustomRoute(
          page: ConfigureWeeklyScheduleRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 400,
        ),
        CustomRoute(
          page: ConfigureHobbyRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 400,
        ),
        CustomRoute(
          page: SignUpSignInRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 400,
        ),
      ];
}
