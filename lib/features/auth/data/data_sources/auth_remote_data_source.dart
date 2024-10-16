import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/features/auth/data/data_sources/auth_data_source.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/services/database_service.dart';

class AuthRemoteDataSource implements AuthDataSource {
  @override
  Future<Either<AuthExeption, UserCredential>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
    required WeeklyScheduleData weeklyScheduleData,
    required List<Hobby> hobbies,
  }) async {
    try {
      // Create the account
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Update the display name
      await credential.user!.updateDisplayName(displayName);

      // Upload the weekly schedule data
      await DatabaseService.uploadWeeklySchedule(
        weeklyScheduleData: weeklyScheduleData,
      );

      // Upload the hobbies
      await DatabaseService.uploadHobbies(
        hobbies: hobbies,
      );

      return Right(credential);
    } on FirebaseAuthException catch (e) {
      logger.e(
        "Error while creation the account.",
        error: e,
      );

      return Left(AuthExeption.fromErrorCode(e.code));
    } catch (e) {
      logger.e(
        "Unknown error occurred, while creating the account.",
        error: e,
      );

      return Left(AuthExeption.unknown());
    }
  }

  @override
  Future<Either<AuthExeption, UserCredential>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Sign the user in
      return Right(
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      logger.e(
        "Error while signing in.",
        error: e,
      );

      return Left(AuthExeption.fromErrorCode(e.code));
    } catch (e) {
      logger.e(
        "Unknown error occurred, while signing in.",
        error: e,
      );

      return Left(AuthExeption.unknown());
    }
  }
}
