import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/functions/check_user_is_signed_in.dart';
import 'package:schulplaner/common/models/event.dart';
import 'package:schulplaner/common/models/hobby.dart';
import 'package:schulplaner/common/models/weekly_schedule_data.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';

abstract class DatabaseService {
  /// Get the weekly schedule data collection from firestore for the current user
  static CollectionReference<Map<String, dynamic>>
      get weeklyScheduleCollection =>
          currentUserDocument.collection("weekly_schedule");

  static CollectionReference<Map<String, dynamic>> get hobbiesCollection =>
      currentUserDocument.collection("hobbies");

  static CollectionReference<Map<String, dynamic>> get eventsCollection =>
      currentUserDocument.collection("events");

  static CollectionReference<Map<String, dynamic>> get userCollection =>
      FirebaseFirestore.instance.collection("users");

  static DocumentReference<Map<String, dynamic>> get currentUserDocument =>
      userCollection.doc(FirebaseAuth.instance.currentUser!.uid);

  static Future<void> uploadWeeklySchedule(
    BuildContext context, {
    required WeeklyScheduleData weeklyScheduleData,
  }) async {
    if (!checkUserIsSignedIn(context)) {
      return;
    }

    // Create a map to store the data and then sync the data to firestore
    final lessonData = <String, dynamic>{};
    for (final lesson in weeklyScheduleData.lessons) {
      lessonData[lesson.uuid] = lesson.toMap();
    }

    // Sync the data to firestore
    await weeklyScheduleCollection.doc("data").set({
      "timeSpans": weeklyScheduleData.timeSpans.map((x) => x.toMap()).toList(),
      "lessons": lessonData,
    });
  }

  static Future<void> uploadTeachers(
    BuildContext context, {
    required List<Teacher> teachers,
  }) async {
    if (!checkUserIsSignedIn(context)) {
      return;
    }

    // Create a map to store the data and then sync the data to firestore
    final data = <String, dynamic>{};
    for (final teacher in teachers) {
      data[teacher.uuid] = teacher.toMap();
    }

    await weeklyScheduleCollection.doc("teachers").set(data);
  }

  static Future<void> uploadSubjects(
    BuildContext context, {
    required List<Subject> subjects,
  }) async {
    if (!checkUserIsSignedIn(context)) {
      return;
    }

    // Create a map to store the data and then sync the data to firestore
    final data = <String, dynamic>{};
    for (final subject in subjects) {
      data[subject.uuid] = subject.toMap();
    }

    await weeklyScheduleCollection.doc("subjects").set(data);
  }

  /// Upload a single or multiple hobbies to firestore. If a user edits an hobby we just overwrite it with this function.
  static Future<void> uploadHobbies(
    BuildContext context, {
    required List<Hobby> hobbies,
  }) async {
    if (!checkUserIsSignedIn(context)) {
      return;
    }

    for (final hobby in hobbies) {
      // Create a seperate doc for each hobby. The doc id is the hobby uuid
      await hobbiesCollection.doc(hobby.uuid).set(hobby.toMap());
    }
  }

  /// Delete a single or multiple hobbies from firestore
  static Future<void> deleteHobbies(
    BuildContext context, {
    required List<Hobby> hobbies,
  }) async {
    if (!checkUserIsSignedIn(context)) {
      return;
    }

    for (final hobby in hobbies) {
      await hobbiesCollection.doc(hobby.uuid).delete();
    }
  }

  static Future<void> uploadEvents(
    BuildContext context, {
    required List<Event> events,
  }) async {
    if (!checkUserIsSignedIn(context)) {
      return;
    }

    List<HomeworkEvent> homeworkEvents = [];
    List<TestEvent> testEvents = [];
    List<FixedEvent> fixedEvents = [];
    List<RepeatingEvent> repeatingEvents = [];

    for (final event in events) {
      switch (event) {
        case HomeworkEvent homeworkEvent:
          homeworkEvents.add(homeworkEvent);
          break;
        case TestEvent testEvent:
          testEvents.add(testEvent);
          break;
        case FixedEvent fixedEvent:
          fixedEvents.add(fixedEvent);
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

    // Try to update, if no document exists, then we create it
    try {
      await eventsCollection.doc("homework").update(homeworkMap);
    } catch (_) {
      await eventsCollection.doc("homework").set(homeworkMap);
    }
    // TODO: Handle other event uploads here
    // await eventsCollection.doc("tests").set({
    //   "tests": testEvents.map((e) => e.toMap()).toList(),
    // });
    // await eventsCollection.doc("fixed").set({
    //   "fixed": fixedEvents.map((e) => e.toMap()).toList(),
    // });
    // await eventsCollection.doc("repeating").set({
    //   "repeating": repeatingEvents.map((e) => e.toMap()).toList(),
    // });
  }
}
