import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/features/weekly_schedule/data/datasources/weekly_schedule_data_source.dart';
import 'package:schulplaner/shared/exeptions/auth_exeptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/services/database_service.dart';

class WeeklyScheduleRemoteDataSource implements WeeklyScheduleDataSource {
  @override
  Future<Either<UnauthenticatedExeption, void>> uploadWeeklyScheduleData({
    required WeeklyScheduleData weeklyScheduleData,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his weekly schedule.");
      return Left(UnauthenticatedExeption());
    }

    // Upload the data to Firestore
    await DatabaseService.weeklyScheduleCollection.doc("data").set(
          weeklyScheduleData.toMap(),
        );

    return const Right(null);
  }

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadLessons({
    required List<Lesson> lessons,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his weekly schedule.");
      return Left(UnauthenticatedExeption());
    }

    // Upload the data to Firestore. Check if the document exists, if not, create it
    final dataDoc = await DatabaseService.weeklyScheduleDocument.get();
    if (dataDoc.exists) {
      await DatabaseService.weeklyScheduleDocument.update(
        {"lessons": lessons.map((e) => e.toMap()).toList()},
      );
    } else {
      await DatabaseService.weeklyScheduleDocument.set(
        {"lessons": lessons.map((e) => e.toMap()).toList()},
      );
    }

    return const Right(null);
  }

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadSubjects({
    required List<Subject> subjects,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his weekly schedule.");
      return Left(UnauthenticatedExeption());
    }

    // Upload the data to Firestore. Check if the document exists, if not, create it
    final dataDoc = await DatabaseService.weeklyScheduleDocument.get();
    if (dataDoc.exists) {
      await DatabaseService.weeklyScheduleDocument.update(
        {"subjects": subjects.map((e) => e.toMap()).toList()},
      );
    } else {
      await DatabaseService.weeklyScheduleDocument.set(
        {"subjects": subjects.map((e) => e.toMap()).toList()},
      );
    }

    return const Right(null);
  }

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadTeachers({
    required List<Teacher> teachers,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his weekly schedule.");
      return Left(UnauthenticatedExeption());
    }

    // Upload the data to Firestore. Check if the document exists, if not, create it
    final dataDoc = await DatabaseService.weeklyScheduleDocument.get();
    if (dataDoc.exists) {
      await DatabaseService.weeklyScheduleDocument.update(
        {"teachers": teachers.map((e) => e.toMap()).toList()},
      );
    } else {
      await DatabaseService.weeklyScheduleDocument.set(
        {"teachers": teachers.map((e) => e.toMap()).toList()},
      );
    }

    return const Right(null);
  }

  @override
  Future<Either<UnauthenticatedExeption, void>> uploadTimeSpans({
    required Set<TimeSpan> timeSpans,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his weekly schedule.");
      return Left(UnauthenticatedExeption());
    }

    // Upload the data to Firestore. Check if the document exists, if not, create it
    final dataDoc = await DatabaseService.weeklyScheduleDocument.get();
    if (dataDoc.exists) {
      await DatabaseService.weeklyScheduleDocument.update(
        {"timeSpans": timeSpans.map((e) => e.toMap()).toList()},
      );
    } else {
      await DatabaseService.weeklyScheduleDocument.set(
        {"timeSpans": timeSpans.map((e) => e.toMap()).toList()},
      );
    }

    return const Right(null);
  }
}
