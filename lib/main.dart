// TODO: Write Firestore rules for database

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/routes/router.dart';
import 'package:schulplaner/config/theme/app_theme.dart';
import 'package:schulplaner/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS || kIsWeb) {
    await FirebaseAppCheck.instance.activate(
      // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
      // argument for `webProvider`
      // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'), // TODO: Add recaptcha-v3-site-key when deploying app to the web
      androidProvider: AndroidProvider.playIntegrity,
      // Cannot configure on ios, because I have no mac
      // appleProvider: AppleProvider.appAttestWithDeviceCheckFallback,
    );
  }

  runApp(
    ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Schulplaner",
      routerConfig: _appRouter.config(
        reevaluateListenable: ReevaluateListenable.stream(
          FirebaseAuth.instance.authStateChanges(),
        ),
      ),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
