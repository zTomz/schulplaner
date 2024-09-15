// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:schulplaner/common/models/hobby.dart' as _i13;
import 'package:schulplaner/common/models/weekly_schedule.dart' as _i12;
import 'package:schulplaner/common/models/weekly_schedule_data.dart' as _i11;
import 'package:schulplaner/features/account_creation/pages/configure_hobbies_page.dart'
    as _i3;
import 'package:schulplaner/features/account_creation/pages/configure_weekly_schedule_page.dart'
    as _i4;
import 'package:schulplaner/features/account_creation/pages/intro_page.dart'
    as _i5;
import 'package:schulplaner/features/account_creation/pages/sign_up_sign_in_page.dart'
    as _i7;
import 'package:schulplaner/features/app_navigation/app_navigation_page.dart'
    as _i1;
import 'package:schulplaner/features/calendar/calendar_page.dart' as _i2;
import 'package:schulplaner/features/overview/overview_page.dart' as _i6;
import 'package:schulplaner/features/weekly_schedule/weekly_schedule_page.dart'
    as _i8;

/// generated route for
/// [_i1.AppNavigationPage]
class AppNavigationRoute extends _i9.PageRouteInfo<void> {
  const AppNavigationRoute({List<_i9.PageRouteInfo>? children})
      : super(
          AppNavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppNavigationRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppNavigationPage();
    },
  );
}

/// generated route for
/// [_i2.CalendarPage]
class CalendarRoute extends _i9.PageRouteInfo<void> {
  const CalendarRoute({List<_i9.PageRouteInfo>? children})
      : super(
          CalendarRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.CalendarPage();
    },
  );
}

/// generated route for
/// [_i3.ConfigureHobbyPage]
class ConfigureHobbyRoute extends _i9.PageRouteInfo<ConfigureHobbyRouteArgs> {
  ConfigureHobbyRoute({
    _i10.Key? key,
    _i11.WeeklyScheduleData? weeklyScheduleData,
    List<_i12.Teacher>? teachers,
    List<_i12.Subject>? subjects,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ConfigureHobbyRoute.name,
          args: ConfigureHobbyRouteArgs(
            key: key,
            weeklyScheduleData: weeklyScheduleData,
            teachers: teachers,
            subjects: subjects,
          ),
          initialChildren: children,
        );

  static const String name = 'ConfigureHobbyRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ConfigureHobbyRouteArgs>(
          orElse: () => const ConfigureHobbyRouteArgs());
      return _i3.ConfigureHobbyPage(
        key: args.key,
        weeklyScheduleData: args.weeklyScheduleData,
        teachers: args.teachers,
        subjects: args.subjects,
      );
    },
  );
}

class ConfigureHobbyRouteArgs {
  const ConfigureHobbyRouteArgs({
    this.key,
    this.weeklyScheduleData,
    this.teachers,
    this.subjects,
  });

  final _i10.Key? key;

  final _i11.WeeklyScheduleData? weeklyScheduleData;

  final List<_i12.Teacher>? teachers;

  final List<_i12.Subject>? subjects;

  @override
  String toString() {
    return 'ConfigureHobbyRouteArgs{key: $key, weeklyScheduleData: $weeklyScheduleData, teachers: $teachers, subjects: $subjects}';
  }
}

/// generated route for
/// [_i4.ConfigureWeeklySchedulePage]
class ConfigureWeeklyScheduleRoute extends _i9.PageRouteInfo<void> {
  const ConfigureWeeklyScheduleRoute({List<_i9.PageRouteInfo>? children})
      : super(
          ConfigureWeeklyScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfigureWeeklyScheduleRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i4.ConfigureWeeklySchedulePage();
    },
  );
}

/// generated route for
/// [_i5.IntroPage]
class IntroRoute extends _i9.PageRouteInfo<void> {
  const IntroRoute({List<_i9.PageRouteInfo>? children})
      : super(
          IntroRoute.name,
          initialChildren: children,
        );

  static const String name = 'IntroRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i5.IntroPage();
    },
  );
}

/// generated route for
/// [_i6.OverviewPage]
class OverviewRoute extends _i9.PageRouteInfo<void> {
  const OverviewRoute({List<_i9.PageRouteInfo>? children})
      : super(
          OverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'OverviewRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i6.OverviewPage();
    },
  );
}

/// generated route for
/// [_i7.SignUpSignInPage]
class SignUpSignInRoute extends _i9.PageRouteInfo<SignUpSignInRouteArgs> {
  SignUpSignInRoute({
    _i10.Key? key,
    _i11.WeeklyScheduleData? weeklyScheduleData,
    List<_i12.Teacher>? teachers,
    List<_i12.Subject>? subjects,
    List<_i13.Hobby>? hobbies,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          SignUpSignInRoute.name,
          args: SignUpSignInRouteArgs(
            key: key,
            weeklyScheduleData: weeklyScheduleData,
            teachers: teachers,
            subjects: subjects,
            hobbies: hobbies,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpSignInRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpSignInRouteArgs>(
          orElse: () => const SignUpSignInRouteArgs());
      return _i7.SignUpSignInPage(
        key: args.key,
        weeklyScheduleData: args.weeklyScheduleData,
        teachers: args.teachers,
        subjects: args.subjects,
        hobbies: args.hobbies,
      );
    },
  );
}

class SignUpSignInRouteArgs {
  const SignUpSignInRouteArgs({
    this.key,
    this.weeklyScheduleData,
    this.teachers,
    this.subjects,
    this.hobbies,
  });

  final _i10.Key? key;

  final _i11.WeeklyScheduleData? weeklyScheduleData;

  final List<_i12.Teacher>? teachers;

  final List<_i12.Subject>? subjects;

  final List<_i13.Hobby>? hobbies;

  @override
  String toString() {
    return 'SignUpSignInRouteArgs{key: $key, weeklyScheduleData: $weeklyScheduleData, teachers: $teachers, subjects: $subjects, hobbies: $hobbies}';
  }
}

/// generated route for
/// [_i8.WeeklySchedulePage]
class WeeklyScheduleRoute extends _i9.PageRouteInfo<void> {
  const WeeklyScheduleRoute({List<_i9.PageRouteInfo>? children})
      : super(
          WeeklyScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'WeeklyScheduleRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.WeeklySchedulePage();
    },
  );
}
