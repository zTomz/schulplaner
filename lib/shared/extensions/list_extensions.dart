import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

extension LessonListExtension on List<Lesson> {
  List<Lesson> getLessonsForDay(DateTime day) => where(
        (lesson) => lesson.weekday == Weekday.fromDateTime(day),
      ).toList(growable: false);
}
