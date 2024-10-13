import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/config/constants/logger.dart';
import 'package:schulplaner/features/weekly_schedule/data/datasources/weekly_schedule_data_source.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
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
}
