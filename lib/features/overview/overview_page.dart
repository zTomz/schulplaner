import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';

@RoutePage()
class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              color: Colors.blue,
            ),
            const Expanded(
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
