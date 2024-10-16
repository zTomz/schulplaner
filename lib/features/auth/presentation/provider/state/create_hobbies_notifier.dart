import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/models/hobby.dart';

class CreateHobbiesNotifier extends StateNotifier<List<Hobby>> {
  CreateHobbiesNotifier() : super([]);

  /// Add a hobby to the list
  void addHobby(Hobby hobby) {
    state = [...state, hobby];
  }

  /// Edit an already existing hobby
  void editHobby(Hobby hobby) {
    state = state
        .map((h) => h.uuid == hobby.uuid ? hobby : h)
        .toList()
        .cast<Hobby>();
  }

  void deleteHobby(Hobby hobby) {
    state = state.where((h) => h.uuid != hobby.uuid).toList();
  }
}
