import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/models.dart';

final selectedSchoolTimeCellProvider = StateProvider<SchoolTimeCell?>((ref) => null);