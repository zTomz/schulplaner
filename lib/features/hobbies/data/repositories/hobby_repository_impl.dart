import 'package:schulplaner/features/hobbies/data/data_sources/hobby_data_source.dart';
import 'package:schulplaner/features/hobbies/domain/repositories/hobbies_repository.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/hobby.dart';

class HobbiesRepositoryImpl implements HobbiesRepository {
  final HobbiesDataSource dataSource;

  const HobbiesRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadHobbies({
    required List<Hobby> hobbies,
  }) async {
    return dataSource.uploadHobbies(hobbies: hobbies);
  }
}
