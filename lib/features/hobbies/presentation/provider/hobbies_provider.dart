import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/hobbies/domain/provider/hobbies_provider.dart';
import 'package:schulplaner/features/hobbies/presentation/provider/state/hobbies_state_notifier.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/provider/hobbies_stream_provider.dart';

final hobbiesProvider =
    StateNotifierProvider<HobbiesStateNotifier, Either<Exception, List<Hobby>>>(
  (ref) {
    final hobbyRepository = ref.watch(hobbiesRepositryProvider);
    final hobbiesStream = ref.watch(
      hobbiesStreamProvider,
    ); // FIXME: Only read the data once and not listen to the stram -> causing unnecessary rebuilds

    return HobbiesStateNotifier(
      hobbiesRepository: hobbyRepository,
      data: hobbiesStream.hasValue
          ? Right(hobbiesStream.value!)
          : Left(Exception(hobbiesStream.error)),
    );
  },
);
