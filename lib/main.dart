import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/config/routes/router.dart';
import 'package:schulplaner/config/theme/app_theme.dart';
import 'package:schulplaner/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MainApp());
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
      theme: AppTheme.darkTheme,
    );
  }
}

/*

BUG: User has to tap 'Start' on windows, because the firebase windows
initialization takes to long. This means the [FirebaseAuth.instance.currentUser]
stays [null] for one second or so (which is to long for router initilization).

GitHub Issue: https://github.com/firebase/flutterfire/issues/12055

Current Workaround:
Added a [SignedInCheckGuard] to all account creation routes. So on windows, you now have to press
the 'Start' button on the first page and then you should be send to the
[NavigationPage].

Update 08.09.2024:
Added the following code to the _appRouter.config method:
reevaluateListenable: ReevaluateListenable.stream(
          FirebaseAuth.instance.authStateChanges(),
        ),

With this it now flickers on windows. But directly navigates to the navigation page

*/