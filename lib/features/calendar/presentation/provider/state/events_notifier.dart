import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/calendar/domain/repositories/events_repository.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/event.dart';

class EventsNotifier extends StateNotifier<Either<Exception, EventData>> {
  final EventsRepository eventsRepository;

  EventsNotifier({
    required this.eventsRepository,
    required Either<Exception, EventData> initialData,
  }) : super(initialData);
}
