import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/calendar/domain/provider/events_provider.dart';
import 'package:schulplaner/features/calendar/presentation/provider/state/events_notifier.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/provider/events_stream_provider.dart';

final eventsProvider =
    StateNotifierProvider<EventsNotifier, Either<Exception, EventData>>(
      (ref) {
        final eventsRepository = ref.watch(eventsRepositoryProvider);
        final eventsStream = ref.watch(eventsStreamProvider);

        return EventsNotifier(
          eventsRepository: eventsRepository,
          initialData: eventsStream.hasValue
              ? Right(eventsStream.value!)
              : Left(Exception(eventsStream.error)),
        );
      },
    );
