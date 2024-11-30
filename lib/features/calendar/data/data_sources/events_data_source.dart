import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/event.dart';

abstract class EventsDataSource {
  /// Uploads events to the database
  Future<Either<UnauthenticatedException, void>> uploadEvents({
    required List<Event> events,
  });
}
