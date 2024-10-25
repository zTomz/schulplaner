import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/weekly_schedule/domain/repositories/weekly_schedule_repository.dart';
import 'package:schulplaner/shared/exceptions/weekly_schedule_exceptions.dart';
import 'package:schulplaner/shared/models/either.dart';
import 'package:schulplaner/shared/models/time.dart';
import 'package:schulplaner/shared/models/weekly_schedule.dart';

class WeeklyScheduleNotifier
    extends StateNotifier<Either<Exception, WeeklyScheduleData>> {
  final WeeklyScheduleRepository weeklyScheduleRepository;

  WeeklyScheduleNotifier({
    required this.weeklyScheduleRepository,
    required Either<Exception, WeeklyScheduleData> initialData,
  }) : super(initialData);

  /// Syncs the current state with the database. If the state has an exeption
  /// it will return and will not sync the data
  Future<void> _syncStateWithDatabase() async {
    if (state.isLeft()) {
      state = Left(
        WeeklyScheduleSyncPreviousException(
          previousException: state.left!,
        ),
      );
      return;
    }

    final result = await weeklyScheduleRepository.uploadWeeklyScheduleData(
      weeklyScheduleData: state.right!,
    );
    result.fold(
      (failure) => state = Left(failure),
      (_) {},
    );
  }

  Future<void> uploadWeeklyScheduleData({
    required WeeklyScheduleData data,
  }) async {
    state = Right(data);

    await _syncStateWithDatabase();
  }

  Future<void> addTimeSpan({
    required TimeSpan timeSpan,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Add a new time span to the set of time spans
    state = Right(state.right!.copyWith(
      timeSpans: {
        ...state.right!.timeSpans,
        timeSpan,
      },
    ));

    await _syncStateWithDatabase();
  }

  Future<void> deleteTimeSpan({
    required TimeSpan timeSpan,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Remove a time span from the set of time spans
    state = Right(state.right!.copyWith(
      timeSpans: state.right!.timeSpans
          .where((element) => element != timeSpan)
          .toSet(),
    ));

    await _syncStateWithDatabase();
  }

  Future<void> addLesson({
    required Lesson lesson,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Add a new lesson to the set of lessons
    state = Right(state.right!.copyWith(
      lessons: [
        ...state.right!.lessons,
        lesson,
      ],
    ));

    await _syncStateWithDatabase();
  }

  Future<void> editLesson({
    required Lesson lesson,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Edit an existing lesson
    state = Right(state.right!.copyWith(
      lessons: state.right!.lessons
          .map(
            (e) => e.uuid == lesson.uuid ? lesson : e,
          )
          .toList(),
    ));

    await _syncStateWithDatabase();
  }

  Future<void> deleteLesson({
    required Lesson lesson,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Remove the lesson from the list of lessons
    state = Right(state.right!.copyWith(
      lessons: state.right!.lessons
          .where(
            (element) => element.uuid != lesson.uuid,
          )
          .toList(),
    ));

    await _syncStateWithDatabase();
  }

  Future<void> addSubject({
    required Subject subject,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Add a new subject to the set of subjects
    state = Right(state.right!.copyWith(
      subjects: [
        ...state.right!.subjects,
        subject,
      ],
    ));

    await _syncStateWithDatabase();
  }

  Future<void> editSubject({
    required Subject subject,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Edit an existing subject
    state = Right(state.right!.copyWith(
      subjects: state.right!.subjects
          .map(
            (e) => e.uuid == subject.uuid ? subject : e,
          )
          .toList(),
    ));

    await _syncStateWithDatabase();
  }

  Future<void> deleteSubject({
    required Subject subject,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Remove the subject from the list of subjects & all lessons containing
    // this subject
    state = Right(state.right!.copyWith(
      subjects: state.right!.subjects
          .where(
            (element) => element.uuid != subject.uuid,
          )
          .toList(),
      lessons: state.right!.lessons
          .where((lesson) => lesson.subjectUuid != subject.uuid)
          .toList(),
    ));

    await _syncStateWithDatabase();
  }

  Future<void> addTeacher({
    required Teacher teacher,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Add a new teacher to the set of teachers
    state = Right(state.right!.copyWith(
      teachers: [
        ...state.right!.teachers,
        teacher,
      ],
    ));

    await _syncStateWithDatabase();
  }

  Future<void> editTeacher({
    required Teacher teacher,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Edit an existing teacher
    state = Right(state.right!.copyWith(
      teachers: state.right!.teachers
          .map(
            (e) => e.uuid == teacher.uuid ? teacher : e,
          )
          .toList(),
    ));

    await _syncStateWithDatabase();
  }

  Future<void> deleteTeacher({
    required Teacher teacher,
  }) async {
    // If an error exists, we return
    if (state.isLeft()) {
      return;
    }

    // Remove the teacher from the list of teachers, all subjects containing this
    // teacher & all lessons containing these subject
    final subjects = state.right!.subjects;

    state = Right(state.right!.copyWith(
      teachers: state.right!.teachers
          .where(
            (element) => element.uuid != teacher.uuid,
          )
          .toList(),
      subjects: state.right!.subjects
          .where(
            (element) => element.teacherUuid != teacher.uuid,
          )
          .toList(),
      lessons: state.right!.lessons
          .where(
            (lesson) =>
                lesson.getSubject(subjects)?.teacherUuid != teacher.uuid,
          )
          .toList(),
    ));

    await _syncStateWithDatabase();
  }
}
