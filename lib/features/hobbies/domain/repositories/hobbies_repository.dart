import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/hobby.dart';

abstract class HobbiesRepository {
  Future<Either<UnauthenticatedExeption, void>> uploadHobbies({
    required List<Hobby> hobbies,
  });
}