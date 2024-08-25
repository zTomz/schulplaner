import 'package:flutter/material.dart';
import 'package:schulplaner/config/routes/router.dart';
import 'package:schulplaner/config/theme/app_theme.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Schulplaner",
      routerConfig: _appRouter.config(),
      theme: AppTheme.darkTheme,
    );
  }
}
