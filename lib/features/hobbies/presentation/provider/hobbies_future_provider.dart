import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/functions/first_where_or_null.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/provider/user_provider.dart';
import 'package:schulplaner/shared/services/database_service.dart';

final hobbiesFutureProvider = FutureProvider<HobbiesData>(
  (ref) async {
    final userStream = ref.watch(userProvider);

    if (userStream.value != null) {
      final rawHobbiesData = await DatabaseService.hobbiesCollection.get();

      return _convertHobbiesSnapshotToData(data: rawHobbiesData);
    } else {
      return Future.error(
        "Sie benötigen ein Konto um diese Aktion auszuführen.",
      );
    }
  },
);

HobbiesData _convertHobbiesSnapshotToData({
  required QuerySnapshot<Map<String, dynamic>> data,
}) {
  List<Hobby> hobbies = [];

  final dataDoc = firstWhereOrNull(data.docs, (doc) => doc.id == "data");

  if (dataDoc != null) {
    for (final MapEntry entry in dataDoc.data().entries) {
      final hobby = Hobby.fromMap(entry.value as Map<String, dynamic>);
      hobbies.add(hobby);
    }
  }

  return hobbies;
}
