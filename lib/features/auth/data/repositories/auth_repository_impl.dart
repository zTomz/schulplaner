import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/features/auth/data/data_source/auth_data_source.dart';
import 'package:schulplaner/features/auth/domain/repositories/auth_repository.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<AuthExeption, UserCredential>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
    required WeeklyScheduleData weeklyScheduleData,
    required List<Hobby> hobbies,
  }) async {
    return dataSource.signUpWithEmailPassword(
      email: email,
      password: password,
      displayName: displayName,
      weeklyScheduleData: weeklyScheduleData,
      hobbies: hobbies,
    );
  }

  @override
  Future<Either<AuthExeption, UserCredential>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return dataSource.signInWithEmailPassword(email: email, password: password);
  }
}
