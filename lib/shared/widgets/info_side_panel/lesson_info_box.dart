import 'package:flutter/material.dart';
import 'package:schulplaner/config/constants/numbers.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/custom/custom_color_indicator.dart';
import 'package:schulplaner/shared/widgets/info_side_panel/info_box_position.dart';

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

    return ListTile(
      leading: CustomColorIndicator(color: subject?.color ?? Colors.transparent),
      minLeadingWidth: CustomColorIndicator(color: subject?.color ?? Colors.transparent).preferredSize.width,
      title: Text(subject?.name ?? "Fehler"),
      subtitle: Text(lesson.timeSpan.toFormattedString()),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: position.shape,
    );
  }
}
