import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/provider/user_provider.dart';
import 'package:schulplaner/shared/services/database_service.dart';

final hobbiesStreamProvider = StreamProvider<List<Hobby>>(
  (ref) {
    final userStream = ref.watch(userProvider);

    if (userStream.value != null) {
      return DatabaseService.hobbiesCollection.doc("data").snapshots().map(
            (value) => (value.data()?.entries ?? [])
                .map(
                  (hobbyUuid) => Hobby.fromMap(
                    value.data()![hobbyUuid.key] as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );
    } else {
      return Stream.error(
        "Sie benötigen einen Account um diese Aktion auszuführen.",
      );
    }
  },
);
