import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/calendar/domain/provider/events_provider.dart';
import 'package:schulplaner/features/calendar/presentation/provider/events_future_provider.dart';
import 'package:schulplaner/features/calendar/presentation/provider/state/events_notifier.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/event.dart';

final eventsProvider =
    StateNotifierProvider<EventsNotifier, Either<Exception, EventData>>(
  (ref) {
    final eventsRepository = ref.watch(eventsRepositoryProvider);
    final eventsFuture = ref.watch(eventsFutureProvider);

    return EventsNotifier(
      eventsRepository: eventsRepository,
      initialData: eventsFuture.hasValue || eventsFuture.isLoading
          ? Right(
              eventsFuture.isLoading ? [] : eventsFuture.value!,
            )
          : Left(Exception("Die Ereignisse konnten nicht geladen werden")),
    );
  },
);
