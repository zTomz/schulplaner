import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/models.dart';

extension LessonListExtension on List<Lesson> {
  List<Lesson> getLessonsForDay(DateTime day, {Week? week}) => where(
        (lesson) =>
            lesson.weekday == Weekday.fromDateTime(day) &&
            ((week == null || week == Week.all) || (lesson.week == week || lesson.week == Week.all)),
      ).toList(growable: false);
}
