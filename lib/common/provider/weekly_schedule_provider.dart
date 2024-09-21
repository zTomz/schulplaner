import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/common/models/time.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';
import 'package:schulplaner/common/provider/user_provider.dart';
import 'package:schulplaner/common/services/database_service.dart';

final weeklyScheduleProvider = StreamProvider<
    (
      List<Lesson> lessons,
      Set<TimeSpan> timeSpans,
      List<Teacher> teachers,
      List<Subject> subjects,
    )?>(
  (ref) {
    final userStream = ref.watch(userProvider);

    final user = userStream.value;

    if (user != null) {
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

(
  List<Lesson> lessons,
  Set<TimeSpan> timeSpans,
  List<Teacher> teachers,
  List<Subject> subjects,
) _convertWeeklyScheduleSnapshotToData({
  required QuerySnapshot<Map<String, dynamic>> data,
}) {
  List<Lesson> lessons = [];
  Set<TimeSpan> timeSpans = {};
  List<Teacher> teachers = [];
  List<Subject> subjects = [];

  // Get the teachers
  final teacherDoc = data.docs.where((doc) => doc.id == "teachers").firstOrNull;
  if (teacherDoc != null) {
    final teacherData = teacherDoc.data();
    for (final entry in teacherData.entries) {
      teachers.add(
        Teacher.fromMap(teacherData[entry.key] as Map<String, dynamic>),
      );
    }
  }

  // Get the lessons
  final lessonDoc = data.docs.where((doc) => doc.id == "data").firstOrNull;
  if (lessonDoc != null) {
    final lessonData = lessonDoc.data();

    for (final entry in lessonData["lessons"].entries) {
      lessons.add(Lesson.fromMap(
        lessonData["lessons"][entry.key] as Map<String, dynamic>,
      ));
    }
  }

  // Get the time spans
  final timeSpanDoc = data.docs.where((doc) => doc.id == "data").firstOrNull;
  if (timeSpanDoc != null) {
    final timeSpanData = timeSpanDoc.data();

    for (int i = 0;
        i < (timeSpanData["timeSpans"] as List<dynamic>).length;
        i++) {
      timeSpans.add(TimeSpan.fromMap(
        timeSpanData["timeSpans"][i] as Map<String, dynamic>,
      ));
    }
  }

  // Get the subjects
  final subjectDoc = data.docs.where((doc) => doc.id == "subjects").firstOrNull;
  if (subjectDoc != null) {
    final subjectData = subjectDoc.data();
    for (final entry in subjectData.entries) {
      subjects.add(
        Subject.fromMap(subjectData[entry.key] as Map<String, dynamic>),
      );
    }
  }

  return (
    lessons,
    timeSpans,
    teachers,
    subjects,
  );
}
