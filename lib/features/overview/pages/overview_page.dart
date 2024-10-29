import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/features/overview/widgets/overview_side_panel.dart';
import 'package:schulplaner/shared/widgets/floating_action_buttons/event_floating_action_button.dart';

@RoutePage()
class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const EventFloatingActionButton(),
      body: const Padding(
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
