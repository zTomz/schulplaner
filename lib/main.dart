import 'package:flutter/material.dart';
import 'package:schulplaner/config/theme/app_theme.dart';
import 'package:schulplaner/features/account_creation/pages/intro_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: const IntroPage(),
    );
  }
}
