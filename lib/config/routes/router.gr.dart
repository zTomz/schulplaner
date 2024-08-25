// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:schulplaner/features/account_creation/pages/configure_hobby_page.dart'
    as _i1;
import 'package:schulplaner/features/account_creation/pages/configure_weekly_schedule_page.dart'
    as _i2;
import 'package:schulplaner/features/account_creation/pages/intro_page.dart'
    as _i3;

/// generated route for
/// [_i1.ConfigureHobbyPage]
class ConfigureHobbyRoute extends _i4.PageRouteInfo<void> {
  const ConfigureHobbyRoute({List<_i4.PageRouteInfo>? children})
      : super(
          ConfigureHobbyRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfigureHobbyRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.ConfigureHobbyPage();
    },
  );
}

/// generated route for
/// [_i2.ConfigureWeeklySchedulePage]
class ConfigureWeeklyScheduleRoute extends _i4.PageRouteInfo<void> {
  const ConfigureWeeklyScheduleRoute({List<_i4.PageRouteInfo>? children})
      : super(
          ConfigureWeeklyScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfigureWeeklyScheduleRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.ConfigureWeeklySchedulePage();
    },
  );
}

/// generated route for
/// [_i3.IntroPage]
class IntroRoute extends _i4.PageRouteInfo<void> {
  const IntroRoute({List<_i4.PageRouteInfo>? children})
      : super(
          IntroRoute.name,
          initialChildren: children,
        );

  static const String name = 'IntroRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.IntroPage();
    },
  );
}
