import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/hobbies/domain/repositories/hobbies_repository.dart';
import 'package:schulplaner/shared/exceptions/hobbies_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/hobby.dart';

class HobbiesStateNotifier
    extends StateNotifier<Either<Exception, List<Hobby>>> {
  final HobbiesRepository hobbiesRepository;

  HobbiesStateNotifier({
    required this.hobbiesRepository,
    required Either<Exception, List<Hobby>> initialData,
  }) : super(initialData);

  /// Syncs the current state with the database. If the state has an exeption
  /// it will return and will not sync the data
  Future<void> _syncStateWithDatabase() async {
    if (state.isLeft()) {
      state = Left(
        HobbiesSyncPreviousException(
          previousException: state.left!,
        ),
      );
      return;
    }

    final result = await hobbiesRepository.uploadHobbies(
      hobbies: state.right!,
    );
    result.fold(
      (failure) => state = Left(failure),
      (_) {},
    );
  }

  Future<void> addHobby({
    required Hobby hobby,
  }) async {
    // Add a new hobby to the state
    state = Right([...state.right!, hobby]);

    await _syncStateWithDatabase();
  }

  Future<void> editHobby({
    required Hobby hobby,
  }) async {
    // Edit an existing hobby
    state = Right(
      state.right!.map((e) => e.uuid == hobby.uuid ? hobby : e).toList(),
    );

    await _syncStateWithDatabase();
  }

  Future<void> deleteHobby({
    required Hobby hobby,
  }) async {
    // Remove the hobby from the state
    state = Right(state.right!.where((element) => element.uuid != hobby.uuid).toList());

    await _syncStateWithDatabase();
  }
}
