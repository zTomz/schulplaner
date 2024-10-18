import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/provider/user_provider.dart';
import 'package:schulplaner/shared/services/database_service.dart';

final eventsFutureProvider = FutureProvider<EventData>(
  (ref) async {
    final userStream = ref.watch(userProvider);

    if (userStream.value != null) {
      final rawEventsData = await DatabaseService.eventsCollection.get();

      return _convertEventsSnapshotToData(data: rawEventsData);
    } else {
      return Future.error(
        "Sie benötigen einen Account um diese Aktion auszuführen.",
      );
    }
  },
);
EventData _convertEventsSnapshotToData({
  required QuerySnapshot<Map<String, dynamic>> data,
}) {
  EventData events = [];

  final dataDoc = data.docs.where((doc) => doc.id == "data").firstOrNull;

  if (dataDoc != null) {
    final eventData = dataDoc.data();
    for (final entry in eventData.entries) {
      events.add(
        Event.fromMap(eventData[entry.key] as Map<String, dynamic>),
      );
    }
  }

  return events;
}
