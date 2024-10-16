import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/provider/user_provider.dart';
import 'package:schulplaner/shared/services/database_service.dart';

final eventsStreamProvider = StreamProvider<EventData>(
  (ref) {
    final userStream = ref.watch(userProvider);

    if (userStream.value != null) {
      return DatabaseService.eventsCollection.snapshots().map(
            (value) => _convertEventsSnapshotToData(data: value),
          );
    } else {
      return Stream.error(
        "Sie benötigen einen Account um diese Aktion auszuführen.",
      );
    }
  },
);

EventData _convertEventsSnapshotToData({
  required QuerySnapshot<Map<String, dynamic>> data,
}) {
  List<HomeworkEvent> homeworkEvents = [];
  List<TestEvent> testEvents = [];
  List<ReminderEvent> reminderEvents = [];
  List<RepeatingEvent> repeatingEvents = [];

  // Get the homework events
  final homeworkDoc = data.docs
      .where(
        (doc) => doc.id == "homework",
      )
      .firstOrNull;

  if (homeworkDoc != null) {
    final homeworkData = homeworkDoc.data();
    for (final entry in homeworkData.entries) {
      homeworkEvents.add(
        HomeworkEvent.fromMap(homeworkData[entry.key] as Map<String, dynamic>),
      );
    }
  }

  // Get the test events
  final testDoc = data.docs
      .where(
        (doc) => doc.id == "tests",
      )
      .firstOrNull;

  if (testDoc != null) {
    final testData = testDoc.data();
    for (final entry in testData.entries) {
      testEvents.add(
        TestEvent.fromMap(testData[entry.key] as Map<String, dynamic>),
      );
    }
  }

  // Get the reminder events
  final reminderDoc = data.docs
      .where(
        (doc) => doc.id == "reminder",
      )
      .firstOrNull;

  if (reminderDoc != null) {
    final reminderEventsData = reminderDoc.data();
    for (final entry in reminderEventsData.entries) {
      reminderEvents.add(
        ReminderEvent.fromMap(
          reminderEventsData[entry.key] as Map<String, dynamic>,
        ),
      );
    }
  }

  // TODO: Handle the other events here and convert them

  return EventData(
    homeworkEvents: homeworkEvents,
    testEvents: testEvents,
    reminderEvents: reminderEvents,
    repeatingEvents: repeatingEvents,
  );
}
