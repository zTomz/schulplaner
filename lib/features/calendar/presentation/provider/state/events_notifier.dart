import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/features/calendar/domain/repositories/events_repository.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/exceptions/events_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/event.dart';

class EventsNotifier extends StateNotifier<Either<Exception, EventData>> {
  final EventsRepository eventsRepository;

  EventsNotifier({
    required this.eventsRepository,
    required Either<Exception, EventData> initialData,
  }) : super(initialData);

  /// Syncs the current state with the database. If the state has an exeption
  /// it will return and will not sync the data
  Future<void> _syncStateWithDatabase() async {
    if (state.isLeft()) {
      state = Left(
        EventsSyncPreviousException(
          previousException: state.left!,
        ),
      );
      return;
    }

    try {
      final result = await eventsRepository.uploadEvents(
        events: state.right!,
      );
      result.fold(
        (failure) => state = Left(failure),
        (_) {},
      );
    } on UnauthenticatedException catch (e) {
      state = Left(e);
    } catch (e) {
      logger.e("Got un unexpected exception while syncing events: $e");
      state = Left(Exception(e));
    }
  }

  /// Add a new event to the state
  Future<void> addEvent({
    required Event event,
  }) async {
    if (state.isLeft()) {
      return;
    }

    state = Right(
      [...state.right!, event],
    );

    await _syncStateWithDatabase();
  }

  /// Edit an already existing event. This will replace the event in the state with the new one
  Future<void> editEvent({
    required Event event,
  }) async {
    if (state.isLeft()) {
      return;
    }

    state = Right(
      state.right!.map((e) => e.uuid == event.uuid ? event : e).toList(),
    );

    await _syncStateWithDatabase();
  }

  /// Remove an event from the state
  Future<void> deleteEvent({
    required Event event,
  }) async {
    if (state.isLeft()) {
      return;
    }

    state = Right(
      state.right!.where((e) => e.uuid != event.uuid).toList(),
    );

    await _syncStateWithDatabase();
  }
}
