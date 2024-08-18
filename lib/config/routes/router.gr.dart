// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:schulplaner/features/account_creation/pages/configure_timetable_page.dart'
    as _i1;
import 'package:schulplaner/features/account_creation/pages/intro_page.dart'
    as _i2;

/// generated route for
/// [_i1.ConfigureTimetablePage]
class ConfigureTimetableRoute extends _i3.PageRouteInfo<void> {
  const ConfigureTimetableRoute({List<_i3.PageRouteInfo>? children})
      : super(
          ConfigureTimetableRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfigureTimetableRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.ConfigureTimetablePage();
    },
  );
}

/// generated route for
/// [_i2.IntroPage]
class IntroRoute extends _i3.PageRouteInfo<void> {
  const IntroRoute({List<_i3.PageRouteInfo>? children})
      : super(
          IntroRoute.name,
          initialChildren: children,
        );

  static const String name = 'IntroRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.IntroPage();
    },
  );
}
