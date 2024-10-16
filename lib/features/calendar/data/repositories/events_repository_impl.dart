import 'package:schulplaner/features/calendar/data/data_sources/events_data_source.dart';
import 'package:schulplaner/features/calendar/domain/repositories/events_repository.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/event.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsDataSource dataSource;

  EventsRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadEvents({
    required List<Event> events,
  }) async {
    return dataSource.uploadEvents(events: events);
  }
}
