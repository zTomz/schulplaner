import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

abstract class AuthRepository {
  /// Create a new user with the provided email and password
  Future<Either<AuthExeption, UserCredential>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
    required WeeklyScheduleData weeklyScheduleData,
    required List<Hobby> hobbies,
  });

  /// Sign the user in with the provided email and password
  Future<Either<AuthExeption, UserCredential>> signInWithEmailPassword({
    required String email,
    required String password,
  });
}
