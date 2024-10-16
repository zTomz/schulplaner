import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/hobby.dart';

abstract class HobbiesDataSource {
  /// Upload hobbies to database
  Future<Either<UnauthenticatedExeption, void>> uploadHobbies({required List<Hobby> hobbies}); // (7,2)-(9,4>
}