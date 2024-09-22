import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/provider/user_provider.dart';
import 'package:schulplaner/common/services/database_service.dart';

final eventsProvider = StreamProvider<
    (
      List<HomeworkEvent> homeworkEvents,
      List<TestEvent> testEvents,
      List<FixedEvent> fixedEvents,
      List<RepeatingEvent> repeatingEvents
    )>(
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

(
  List<HomeworkEvent> homeworkEvents,
  List<TestEvent> testEvents,
  List<FixedEvent> fixedEvents,
  List<RepeatingEvent> repeatingEvents
) _convertEventsSnapshotToData({
  required QuerySnapshot<Map<String, dynamic>> data,
}) {
  List<HomeworkEvent> homeworkEvents = [];
  List<TestEvent> testEvents = [];
  List<FixedEvent> fixedEvents = [];
  List<RepeatingEvent> repeatingEvents = [];

  // Get the homework events
  final homeworkDoc = data.docs
      .where(
        (doc) => doc.id == "homework",
      )
      .firstOrNull;

    print("Homework doc data: ${homeworkDoc?.data()}");

  if (homeworkDoc != null) {
    final homeworkData = homeworkDoc.data();
    print("Test");
    for (final entry in homeworkData.entries) {
      homeworkEvents.add(
        HomeworkEvent.fromMap(homeworkData[entry.key] as Map<String, dynamic>),
      );
    }
  }

  // TODO: Handle the other events here and convert them

  return (homeworkEvents, testEvents, fixedEvents, repeatingEvents);
}
