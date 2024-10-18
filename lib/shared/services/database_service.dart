import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schulplaner/shared/models/event.dart';
import 'package:schulplaner/shared/models/hobby.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';
import 'package:schulplaner/shared/exceptions/auth_exceptions.dart';
import 'package:schulplaner/config/constants/logger.dart';

abstract class DatabaseService {
  /// The weekly schedule collection from Firestore for the current user
  static CollectionReference<Map<String, dynamic>>
      get weeklyScheduleCollection =>
          currentUserDocument.collection("weekly_schedule");

  static DocumentReference<Map<String, dynamic>> get weeklyScheduleDocument =>
      weeklyScheduleCollection.doc("data");

  /// The hobbies collection from Firestore for the current user
  static CollectionReference<Map<String, dynamic>> get hobbiesCollection =>
      currentUserDocument.collection("hobbies");

  /// The events collection from Firestore for the current user
  static CollectionReference<Map<String, dynamic>> get eventsCollection =>
      currentUserDocument.collection("events");

  /// The users collection from Firestore
  static CollectionReference<Map<String, dynamic>> get userCollection =>
      FirebaseFirestore.instance.collection("users");

  /// The document of the currently signed in user
  static DocumentReference<Map<String, dynamic>> get currentUserDocument =>
      userCollection.doc(FirebaseAuth.instance.currentUser!.uid);

  static Future<void> uploadWeeklySchedule({
    required WeeklyScheduleData weeklyScheduleData,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his weekly schedule.");
      throw UnauthenticatedExeption();
    }

    // Upload the data to Firestore
    await weeklyScheduleCollection.doc("data").set(
          weeklyScheduleData.toMap(),
        );
  }

  static Future<void> uploadTeachers({
    required List<Teacher> teachers,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his teachers.");
      throw UnauthenticatedExeption();
    }

    // Create a map to store the data and then sync the data to Firestore
    final data = <String, dynamic>{};
    for (final teacher in teachers) {
      data[teacher.uuid] = teacher.toMap();
    }

    await weeklyScheduleCollection.doc("teachers").set(data);
  }

  static Future<void> uploadSubjects({
    required List<Subject> subjects,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his subjects.");
      throw UnauthenticatedExeption();
    }

    // Create a map to store the data and then sync the data to firestore
    final data = <String, dynamic>{};
    for (final subject in subjects) {
      data[subject.uuid] = subject.toMap();
    }

    await weeklyScheduleCollection.doc("subjects").set(data);
  }

  /// Upload a single or multiple hobbies to firestore. If a user edits an hobby we just overwrite it with this function.
  static Future<void> uploadHobbies({
    required List<Hobby> hobbies,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his hobbies.");
      throw UnauthenticatedExeption();
    }

    for (final hobby in hobbies) {
      // Create a seperate doc for each hobby. The doc id is the hobby uuid
      await hobbiesCollection.doc(hobby.uuid).set(hobby.toMap());
    }
  }

  /// Delete a single or multiple hobbies from firestore
  static Future<void> deleteHobbies({
    required List<Hobby> hobbies,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to delete his hobbies.");
      throw UnauthenticatedExeption();
    }

    for (final hobby in hobbies) {
      await hobbiesCollection.doc(hobby.uuid).delete();
    }
  }

  static Future<void> uploadEvents({
    required List<Event> events,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e("The user need to be signed in to upload his events.");
      throw UnauthenticatedExeption();
    }

    eventsCollection.doc('data').set(
      {
        for (final event in events.where(
          (event) => event.type != EventTypes.unimplemented,
        ))
          event.uuid: switch (event.type) {
            EventTypes.homework => (event as HomeworkEvent).toMap(),
            EventTypes.test => (event as TestEvent).toMap(),
            EventTypes.reminder => (event as ReminderEvent).toMap(),
            EventTypes.repeating => (event as RepeatingEvent).toMap(),
            EventTypes.unimplemented => () {
                // This should not happen, because we filter the events before
                logger.e(
                  "Got an unimplemented event type! This should not happen at this point.",
                );
              },
          },
      },
    );
  }
}
