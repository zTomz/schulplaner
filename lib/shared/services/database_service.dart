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

    List<HomeworkEvent> homeworkEvents = [];
    List<TestEvent> testEvents = [];
    List<ReminderEvent> reminderEvents = [];
    List<RepeatingEvent> repeatingEvents = [];

    for (final event in events) {
      switch (event) {
        case HomeworkEvent homeworkEvent:
          homeworkEvents.add(homeworkEvent);
          break;
        case TestEvent testEvent:
          testEvents.add(testEvent);
          break;
        case ReminderEvent reminderEvent:
          reminderEvents.add(reminderEvent);
          break;
        case RepeatingEvent repeatingEvent:
          repeatingEvents.add(repeatingEvent);
          break;
      }
    }

    // Create a map to store the data and then sync the data to firestore
    final homeworkMap = <String, dynamic>{};
    for (final homework in homeworkEvents) {
      homeworkMap[homework.uuid] = homework.toMap();
    }

    if (homeworkMap.isEmpty) {
      await eventsCollection.doc("homework").delete();
    } else {
      await eventsCollection.doc("homework").set(homeworkMap);
    }

    // Upload test events
    final testMap = <String, dynamic>{};
    for (final test in testEvents) {
      testMap[test.uuid] = test.toMap();
    }

    if (testMap.isEmpty) {
      await eventsCollection.doc("tests").delete();
    } else {
      await eventsCollection.doc("tests").set(testMap);
    }

    // Upload ReminderEvent events
    final reminderEventsMap = <String, dynamic>{};
    for (final reminderEvent in reminderEvents) {
      reminderEventsMap[reminderEvent.uuid] = reminderEvent.toMap();
    }

    if (reminderEventsMap.isEmpty) {
      await eventsCollection.doc("reminder").delete();
    } else {
      await eventsCollection.doc("reminder").set(reminderEventsMap);
    }

    // TODO: Handle other event uploads here
    // await eventsCollection.doc("repeating").set({
    //   "repeating": repeatingEvents.map((e) => e.toMap()).toList(),
    // });
  }
}
