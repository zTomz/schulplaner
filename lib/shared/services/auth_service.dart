import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/services/database_service.dart';

abstract class AuthService {
  static Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
    required WeeklyScheduleData weeklyScheduleData,
    required List<Hobby> hobbies,
  }) async {
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

    return credential;
  }

  static Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    // Sign the user in
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }
}
