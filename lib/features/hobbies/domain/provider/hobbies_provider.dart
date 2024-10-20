import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/hobbies/data/data_sources/hobby_data_source.dart';
import 'package:schulplaner/features/hobbies/data/data_sources/hobby_remote_data_source.dart';
import 'package:schulplaner/features/hobbies/data/repositories/hobby_repository_impl.dart';
import 'package:schulplaner/features/hobbies/domain/repositories/hobbies_repository.dart';

final hobbiesDataSourceProvider = Provider<HobbiesDataSource>(
  (ref) => HobbiesRemoteDataSource(),
);

final hobbiesRepositryProvider = Provider<HobbiesRepository>((ref) {
  final dataSource = ref.watch(hobbiesDataSourceProvider);

  return HobbiesRepositoryImpl(
    dataSource: dataSource,
  );
});
