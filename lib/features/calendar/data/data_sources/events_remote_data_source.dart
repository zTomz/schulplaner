import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/features/calendar/data/data_sources/events_data_source.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/services/database_service.dart';

class EventsRemoteDataSource implements EventsDataSource {
  @override
  Future<Either<UnauthenticatedExeption, void>> uploadEvents({
    required List<Event> events,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his events.");
      return Left(UnauthenticatedExeption());
    }

    await DatabaseService.uploadEvents(events: events);

    return const Right(null);
  }
}
