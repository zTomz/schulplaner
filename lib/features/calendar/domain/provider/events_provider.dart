import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/calendar/data/data_sources/events_data_source.dart';
import 'package:schulplaner/features/calendar/data/data_sources/events_remote_data_source.dart';
import 'package:schulplaner/features/calendar/data/repositories/events_repository_impl.dart';
import 'package:schulplaner/features/calendar/domain/repositories/events_repository.dart';

final eventsDataSourceProvider = Provider<EventsDataSource>((ref) {
  return EventsRemoteDataSource();
});

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  final dataSource = ref.watch(eventsDataSourceProvider);

  return EventsRepositoryImpl(dataSource: dataSource);
});