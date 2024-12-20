// TODO: Write Firestore rules for database

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/routes/router.dart';
import 'package:schulplaner/config/theme/app_theme.dart';
import 'package:schulplaner/firebase_options.dart';
import 'package:schulplaner/shared/functions/load_licenses.dart';
import 'package:schulplaner/shared/provider/custom_provider_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if (!Platform.isWindows && !Platform.isLinux) {
  //   await FirebaseMessaging.instance.setAutoInitEnabled(true);
  //   final _ = await FirebaseMessaging.instance.requestPermission(
  //     provisional: true,
  //   );

  //   final fcmToken = await FirebaseMessaging.instance.getToken();
  //   if (FirebaseAuth.instance.currentUser != null && fcmToken != null) {
  //     UserService.updateFCMToken(fcmToken: fcmToken);
  //   }

  //   FirebaseMessaging.instance.onTokenRefresh.listen((token) {
  //     if (FirebaseAuth.instance.currentUser != null) {
  //       UserService.updateFCMToken(fcmToken: token);
  //     }
  //   }).onError((err) {
  //     // TODO: Handle error Error getting token.
  //   });
  // }

  loadLicenses();

  runApp(
    ProviderScope(
      observers: [
        CustomProviderObserver(),
      ],
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de'), // Deutsch
        Locale('en'), // Englisch
        Locale('fr'), // Französisch
      ],
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
