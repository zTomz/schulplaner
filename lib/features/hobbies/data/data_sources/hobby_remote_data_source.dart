import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/features/hobbies/data/data_sources/hobby_data_source.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/services/database_service.dart';

class HobbiesRemoteDataSource implements HobbiesDataSource {
  @override
  Future<Either<UnauthenticatedException, void>> uploadHobbies({
    required List<Hobby> hobbies,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his hobbies.");
      return Left(UnauthenticatedException());
    }

    // Upload the data to Firestore
    await DatabaseService.uploadHobbies(hobbies: hobbies);

    return const Right(null);
  }
}
