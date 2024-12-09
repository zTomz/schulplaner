import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/custom/custom_color_indicator.dart';
import 'package:schulplaner/shared/widgets/info_side_panel/info_box_position.dart';
import 'package:schulplaner/shared/widgets/info_side_panel/special_info_box.dart';

class LessonInfoBox extends StatelessWidget {
  final Lesson lesson;

  /// A list of all available subjects
  final List<Subject> subjects;

  /// Where the info box is displayed in the list view. Used for the border radius
  final InfoBoxPosition position;

  const LessonInfoBox({
    super.key,
    required this.lesson,
    required this.subjects,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final subject = lesson.getSubject(subjects);

    return Container(
      padding: const EdgeInsets.all(Spacing.medium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.vertical(
          top: position == InfoBoxPosition.top ||
                  position == InfoBoxPosition.isSingleItem
              ? Radii.small
              : Radius.zero,
          bottom: position == InfoBoxPosition.bottom ||
                  position == InfoBoxPosition.isSingleItem
              ? Radii.small
              : Radius.zero,
        ),
      ),
      child: Row(
        children: [
          CustomColorIndicator(color: subject?.color ?? Colors.transparent),
          const SizedBox(width: Spacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject?.name ?? "Fehler",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SpecialInfoBox(
                  icon: const Icon(LucideIcons.clock),
                  text: Text(
                    lesson.timeSpan.toFormattedString(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
