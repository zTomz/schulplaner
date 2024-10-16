import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/auth/presentation/provider/state/create_hobbies_notifier.dart';
import 'package:schulplaner/shared/models/hobby.dart';

final createHobbiesProvider =
    StateNotifierProvider<CreateHobbiesNotifier, List<Hobby>>(
  (ref) => CreateHobbiesNotifier(),
);
