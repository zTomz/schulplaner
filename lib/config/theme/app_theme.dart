import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: lightScheme(),
    visualDensity: VisualDensity.standard,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(
        brightness: Brightness.light,
      ).textTheme,
    ).copyWith(
      displayLarge: const TextStyle(
        fontSize: 70,
      ),
      displayMedium: const TextStyle(
        fontSize: 50,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 16,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xffeeeeee), // Surface container
      foregroundColor: Color(0xff006e29), // Primary
    ),
    iconTheme: const IconThemeData(
      color: Color(0xff1b1b1b), // On surface
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: const Color(0xff1b1b1b), // On surface
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: darkScheme(),
    visualDensity: VisualDensity.standard,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).copyWith(
      displayLarge: const TextStyle(
        fontSize: 70,
      ),
      displayMedium: const TextStyle(
        fontSize: 50,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 16,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xff1f1f1f), // Surface container
      foregroundColor: Color(0xff55e071), // Primary
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    ),
  );

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006e29),
      surfaceTint: Color(0xff006e29),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff24ba50),
      onPrimaryContainer: Color(0xff001c05),
      secondary: Color(0xff003ece),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3965ff),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff005db8),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff68a2ff),
      onTertiaryContainer: Color(0xff001634),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff1b1b1b),
      onSurfaceVariant: Color(0xff444748),
      outline: Color(0xff747878),
      outlineVariant: Color(0xffc4c7c7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xff55e071),
      primaryFixed: Color(0xff73fe8a),
      onPrimaryFixed: Color(0xff002107),
      primaryFixedDim: Color(0xff55e071),
      onPrimaryFixedVariant: Color(0xff00531d),
      secondaryFixed: Color(0xffdde1ff),
      onSecondaryFixed: Color(0xff001454),
      secondaryFixedDim: Color(0xffb8c4ff),
      onSecondaryFixedVariant: Color(0xff0037ba),
      tertiaryFixed: Color(0xffd6e3ff),
      onTertiaryFixed: Color(0xff001b3e),
      tertiaryFixedDim: Color(0xffaac7ff),
      onTertiaryFixedVariant: Color(0xff00458d),
      surfaceDim: Color(0xffdadada),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffeeeeee),
      surfaceContainerHigh: Color(0xffe8e8e8),
      surfaceContainerHighest: Color(0xffe2e2e2),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff55e071),
      surfaceTint: Color(0xff55e071),
      onPrimary: Color(0xff003911),
      primaryContainer: Color(0xff008734),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffb8c4ff),
      onSecondary: Color(0xff002585),
      secondaryContainer: Color(0xff2c5bf6),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xffaac7ff),
      onTertiary: Color(0xff002f64),
      tertiaryContainer: Color(0xff1a73db),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131313),
      onSurface: Color(0xffe2e2e2),
      onSurfaceVariant: Color(0xffc4c7c7),
      outline: Color(0xff8e9192),
      outlineVariant: Color(0xff444748),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff006e29),
      primaryFixed: Color(0xff73fe8a),
      onPrimaryFixed: Color(0xff002107),
      primaryFixedDim: Color(0xff55e071),
      onPrimaryFixedVariant: Color(0xff00531d),
      secondaryFixed: Color(0xffdde1ff),
      onSecondaryFixed: Color(0xff001454),
      secondaryFixedDim: Color(0xffb8c4ff),
      onSecondaryFixedVariant: Color(0xff0037ba),
      tertiaryFixed: Color(0xffd6e3ff),
      onTertiaryFixed: Color(0xff001b3e),
      tertiaryFixedDim: Color(0xffaac7ff),
      onTertiaryFixedVariant: Color(0xff00458d),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff393939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1b1b1b),
      surfaceContainer: Color(0xff1f1f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353535),
    );
  }
}
