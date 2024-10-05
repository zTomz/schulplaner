import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/common/models/hobby.dart';
import 'package:schulplaner/common/provider/user_provider.dart';
import 'package:schulplaner/common/services/database_service.dart';

final hobbiesProvider = StreamProvider<List<Hobby>>(
  (ref) {
    final userStream = ref.watch(userProvider);

    if (userStream.value != null) {
      return DatabaseService.hobbiesCollection.snapshots().map(
            (value) => value.docs
                .map(
                  (doc) => Hobby.fromMap(
                    doc.data(),
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
