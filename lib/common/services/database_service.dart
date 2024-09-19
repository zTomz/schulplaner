import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner/common/functions/check_user_is_signed_in.dart';
import 'package:schulplaner/common/models/weekly_schedule_data.dart';
import 'package:schulplaner/common/models/weekly_schedule.dart';

abstract class DatabaseService {
  /// Get the weekly schedule data collection from firestore for the current user
  static CollectionReference<Map<String, dynamic>>
      get weeklyScheduleCollection =>
          currentUserDocument.collection("weekly_schedule");

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
}
