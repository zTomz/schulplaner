import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/provider/user_provider.dart';
import 'package:schulplaner/shared/services/database_service.dart';

final hobbiesFutureProvider = FutureProvider<List<Hobby>>(
  (ref) async {
    final userStream = ref.watch(userProvider);

    if (userStream.value != null) {
      final rawHobbiesData = await DatabaseService.hobbiesCollection.get();

      return _convertHobbiesSnapshotToData(data: rawHobbiesData);
    } else {
      return Future.error(
        "Sie benötigen einen Account um diese Aktion auszuführen.",
      );
    }
  },
);

List<Hobby> _convertHobbiesSnapshotToData({
  required QuerySnapshot<Map<String, dynamic>> data,
}) {
  List<Hobby> hobbies = [];

  final dataDoc = data.docs.where((doc) => doc.id == "data").firstOrNull;

  if (dataDoc != null) {
    for (final entry in dataDoc.data().entries) {
      final hobby = Hobby.fromMap(entry.value as Map<String, dynamic>);
      hobbies.add(hobby);
    }
  }

  return hobbies;
}
