import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/provider/user_provider.dart';
import 'package:schulplaner/shared/services/database_service.dart';

final weeklyScheduleFutureProvider = FutureProvider<WeeklyScheduleData>(
  (ref) async {
    final userStream = ref.watch(userProvider);

    if (userStream.value != null) {
      final rawWeeklyScheduleData =
          await DatabaseService.weeklyScheduleCollection.get();

      return _convertWeeklyScheduleSnapshotToData(data: rawWeeklyScheduleData);
    } else {
      return Future.error(
        "Sie benötigen ein Konto um diese Aktion auszuführen.",
      );
    }
  },
);

WeeklyScheduleData _convertWeeklyScheduleSnapshotToData({
  required QuerySnapshot<Map<String, dynamic>> data,
}) {
  Set<TimeSpan> timeSpans = {};
  Set<SchoolLesson> schoolLessons = {};
  List<Lesson> lessons = [];
  List<Teacher> teachers = [];
  List<Subject> subjects = [];

  final dataDoc = data.docs.where((doc) => doc.id == "data").firstOrNull;

  if (dataDoc != null) {
    final dataDocData = dataDoc.data();
    // Load the time spans
    for (int i = 0;
        i < (dataDocData["timeSpans"] as List<dynamic>).length;
        i++) {
      timeSpans.add(TimeSpan.fromMap(
        dataDocData["timeSpans"][i] as Map<String, dynamic>,
      ));
    }

    // Load the school lessons
    for (int i = 0;
        i < ((dataDocData["schoolLessons"] as List<dynamic>?)?.length ?? 0);
        i++) {
      schoolLessons.add(SchoolLesson.fromMap(
        dataDocData["schoolLessons"][i] as Map<String, dynamic>,
      ));
    }

    // Make sure, that school lesson 1 - 10 exists
    for (int i = 1; i <= 10; i++) {
      if (!schoolLessons.map((e) => e.lesson) .contains(i)) {
        schoolLessons.add(
          // If the school lesson does not exist, we add it and set the time span to null
          SchoolLesson(
            lesson: i,
            timeSpan: null,
          ),
        );
      }
    }

    // Load the lessons
    for (int i = 0; i < dataDocData["lessons"].length; i++) {
      lessons.add(Lesson.fromMap(
        dataDocData["lessons"][i] as Map<String, dynamic>,
      ));
    }

    // Load the subjects
    for (int i = 0; i < dataDocData["subjects"].length; i++) {
      subjects.add(Subject.fromMap(
        dataDocData["subjects"][i] as Map<String, dynamic>,
      ));
    }

    // Load the teachers
    for (int i = 0; i < dataDocData["teachers"].length; i++) {
      teachers.add(Teacher.fromMap(
        dataDocData["teachers"][i] as Map<String, dynamic>,
      ));
    }
  }

  return WeeklyScheduleData(
    timeSpans: timeSpans,
    schoolLessons: schoolLessons,
    lessons: lessons,
    subjects: subjects,
    teachers: teachers,
  );
}
