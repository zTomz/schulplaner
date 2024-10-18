import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/hobbies/domain/provider/hobbies_provider.dart';
import 'package:schulplaner/features/hobbies/presentation/provider/state/hobbies_state_notifier.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/features/hobbies/presentation/provider/hobbies_future_provider.dart';

final hobbiesProvider =
    StateNotifierProvider<HobbiesStateNotifier, Either<Exception, List<Hobby>>>(
  (ref) {
    final hobbyRepository = ref.watch(hobbiesRepositryProvider);
    final hobbiesStream = ref.watch(hobbiesFutureProvider);

    return HobbiesStateNotifier(
      hobbiesRepository: hobbyRepository,
      initialData: hobbiesStream.hasValue || hobbiesStream.isLoading
          ? Right(hobbiesStream.isLoading ? [] : hobbiesStream.value!)
          : Left(Exception("Die Hobbys konnten nicht geladen werden")),
    );
  },
);
