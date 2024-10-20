import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/event.dart';

abstract class EventsRepository {
  Future<Either<UnauthenticatedExeption, void>> uploadEvents({
    required List<Event> events,
  });
}
