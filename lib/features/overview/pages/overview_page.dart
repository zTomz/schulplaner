import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/features/overview/widgets/overview_side_panel.dart';

@RoutePage()
class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Spacing.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OverviewSidePanel(),
            Expanded(
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
