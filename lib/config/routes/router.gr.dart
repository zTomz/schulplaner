// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:schulplaner/common/models/hobby.dart' as _i8;
import 'package:schulplaner/features/account_creation/models/create_weekly_schedule_data.dart'
    as _i7;
import 'package:schulplaner/features/account_creation/pages/configure_hobbies_page.dart'
    as _i1;
import 'package:schulplaner/features/account_creation/pages/configure_weekly_schedule_page.dart'
    as _i2;
import 'package:schulplaner/features/account_creation/pages/intro_page.dart'
    as _i3;
import 'package:schulplaner/features/account_creation/pages/sign_up_sign_in_page.dart'
    as _i4;

/// generated route for
/// [_i1.ConfigureHobbyPage]
class ConfigureHobbyRoute extends _i5.PageRouteInfo<ConfigureHobbyRouteArgs> {
  ConfigureHobbyRoute({
    _i6.Key? key,
    required _i7.CreateWeeklyScheduleData createWeeklyScheduleData,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          ConfigureHobbyRoute.name,
          args: ConfigureHobbyRouteArgs(
            key: key,
            createWeeklyScheduleData: createWeeklyScheduleData,
          ),
          initialChildren: children,
        );

  static const String name = 'ConfigureHobbyRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ConfigureHobbyRouteArgs>();
      return _i1.ConfigureHobbyPage(
        key: args.key,
        createWeeklyScheduleData: args.createWeeklyScheduleData,
      );
    },
  );
}

class ConfigureHobbyRouteArgs {
  const ConfigureHobbyRouteArgs({
    this.key,
    required this.createWeeklyScheduleData,
  });

  final _i6.Key? key;

  final _i7.CreateWeeklyScheduleData createWeeklyScheduleData;

  @override
  String toString() {
    return 'ConfigureHobbyRouteArgs{key: $key, createWeeklyScheduleData: $createWeeklyScheduleData}';
  }
}

/// generated route for
/// [_i2.ConfigureWeeklySchedulePage]
class ConfigureWeeklyScheduleRoute extends _i5.PageRouteInfo<void> {
  const ConfigureWeeklyScheduleRoute({List<_i5.PageRouteInfo>? children})
      : super(
          ConfigureWeeklyScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfigureWeeklyScheduleRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.ConfigureWeeklySchedulePage();
    },
  );
}

/// generated route for
/// [_i3.IntroPage]
class IntroRoute extends _i5.PageRouteInfo<void> {
  const IntroRoute({List<_i5.PageRouteInfo>? children})
      : super(
          IntroRoute.name,
          initialChildren: children,
        );

  static const String name = 'IntroRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.IntroPage();
    },
  );
}

/// generated route for
/// [_i4.SignUpSignInPage]
class SignUpSignInRoute extends _i5.PageRouteInfo<SignUpSignInRouteArgs> {
  SignUpSignInRoute({
    _i6.Key? key,
    required _i7.CreateWeeklyScheduleData createWeeklyScheduleData,
    required List<_i8.Hobby> hobbies,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          SignUpSignInRoute.name,
          args: SignUpSignInRouteArgs(
            key: key,
            createWeeklyScheduleData: createWeeklyScheduleData,
            hobbies: hobbies,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpSignInRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpSignInRouteArgs>();
      return _i4.SignUpSignInPage(
        key: args.key,
        createWeeklyScheduleData: args.createWeeklyScheduleData,
        hobbies: args.hobbies,
      );
    },
  );
}

class SignUpSignInRouteArgs {
  const SignUpSignInRouteArgs({
    this.key,
    required this.createWeeklyScheduleData,
    required this.hobbies,
  });

  final _i6.Key? key;

  final _i7.CreateWeeklyScheduleData createWeeklyScheduleData;

  final List<_i8.Hobby> hobbies;

  @override
  String toString() {
    return 'SignUpSignInRouteArgs{key: $key, createWeeklyScheduleData: $createWeeklyScheduleData, hobbies: $hobbies}';
  }
}
