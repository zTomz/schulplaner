// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:schulplaner/features/app_navigation/app_navigation_page.dart'
    as _i1;
import 'package:schulplaner/features/auth/presentation/pages/configure_hobbies_page.dart'
    as _i3;
import 'package:schulplaner/features/auth/presentation/pages/configure_weekly_schedule_page.dart'
    as _i4;
import 'package:schulplaner/features/auth/presentation/pages/intro_page.dart' as _i6;
import 'package:schulplaner/features/auth/presentation/pages/sign_up_sign_in_page.dart'
    as _i8;
import 'package:schulplaner/features/calendar/calendar_page.dart' as _i2;
import 'package:schulplaner/features/hobbies/presentation/pages/hobbies_page.dart' as _i5;
import 'package:schulplaner/features/overview/overview_page.dart' as _i7;
import 'package:schulplaner/features/weekly_schedule/presentation/pages/weekly_schedule_page.dart'
    as _i9;

/// generated route for
/// [_i1.AppNavigationPage]
class AppNavigationRoute extends _i10.PageRouteInfo<void> {
  const AppNavigationRoute({List<_i10.PageRouteInfo>? children})
      : super(
          AppNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppNavigationRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppNavigationPage();
    },
  );
}

/// generated route for
/// [_i2.CalendarPage]
class CalendarRoute extends _i10.PageRouteInfo<void> {
  const CalendarRoute({List<_i10.PageRouteInfo>? children})
      : super(
          CalendarRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i2.CalendarPage();
    },
  );
}

/// generated route for
/// [_i3.ConfigureHobbyPage]
class ConfigureHobbyRoute extends _i10.PageRouteInfo<void> {
  const ConfigureHobbyRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ConfigureHobbyRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfigureHobbyRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i3.ConfigureHobbyPage();
    },
  );
}

/// generated route for
/// [_i4.ConfigureWeeklySchedulePage]
class ConfigureWeeklyScheduleRoute extends _i10.PageRouteInfo<void> {
  const ConfigureWeeklyScheduleRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ConfigureWeeklyScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfigureWeeklyScheduleRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.ConfigureWeeklySchedulePage();
    },
  );
}

/// generated route for
/// [_i5.HobbiesPage]
class HobbiesRoute extends _i10.PageRouteInfo<void> {
  const HobbiesRoute({List<_i10.PageRouteInfo>? children})
      : super(
          HobbiesRoute.name,
          initialChildren: children,
        );

  static const String name = 'HobbiesRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i5.HobbiesPage();
    },
  );
}

/// generated route for
/// [_i6.IntroPage]
class IntroRoute extends _i10.PageRouteInfo<void> {
  const IntroRoute({List<_i10.PageRouteInfo>? children})
      : super(
          IntroRoute.name,
          initialChildren: children,
        );

  static const String name = 'IntroRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i6.IntroPage();
    },
  );
}

/// generated route for
/// [_i7.OverviewPage]
class OverviewRoute extends _i10.PageRouteInfo<void> {
  const OverviewRoute({List<_i10.PageRouteInfo>? children})
      : super(
          OverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'OverviewRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.OverviewPage();
    },
  );
}

/// generated route for
/// [_i8.SignUpSignInPage]
class SignUpSignInRoute extends _i10.PageRouteInfo<SignUpSignInRouteArgs> {
  SignUpSignInRoute({
    _i11.Key? key,
    bool alreadyHasAnAccount = false,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          SignUpSignInRoute.name,
          args: SignUpSignInRouteArgs(
            key: key,
            alreadyHasAnAccount: alreadyHasAnAccount,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpSignInRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpSignInRouteArgs>(
          orElse: () => const SignUpSignInRouteArgs());
      return _i8.SignUpSignInPage(
        key: args.key,
        alreadyHasAnAccount: args.alreadyHasAnAccount,
      );
    },
  );
}

class SignUpSignInRouteArgs {
  const SignUpSignInRouteArgs({
    this.key,
    this.alreadyHasAnAccount = false,
  });

  final _i11.Key? key;

  final bool alreadyHasAnAccount;

  @override
  String toString() {
    return 'SignUpSignInRouteArgs{key: $key, alreadyHasAnAccount: $alreadyHasAnAccount}';
  }
}

/// generated route for
/// [_i9.WeeklySchedulePage]
class WeeklyScheduleRoute extends _i10.PageRouteInfo<void> {
  const WeeklyScheduleRoute({List<_i10.PageRouteInfo>? children})
      : super(
          WeeklyScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'WeeklyScheduleRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.WeeklySchedulePage();
    },
  );
}
