import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/provider/user_provider.dart';
import 'package:schulplaner/shared/services/database_service.dart';

final weeklyScheduleProvider = StreamProvider<WeeklyScheduleData>(
  (ref) {
    final userStream = ref.watch(userProvider);

    if (userStream.value != null) {
      return DatabaseService.weeklyScheduleCollection.snapshots().map(
            (value) => _convertWeeklyScheduleSnapshotToData(data: value),
          );
    } else {
      return Stream.error(
        "Sie benötigen einen Account um diese Aktion auszuführen.",
      );
    }
  },
);

WeeklyScheduleData _convertWeeklyScheduleSnapshotToData({
  required QuerySnapshot<Map<String, dynamic>> data,
}) {
  List<Lesson> lessons = [];
  Set<TimeSpan> timeSpans = {};
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
    lessons: lessons,
    subjects: subjects,
    teachers: teachers,
  );
}
