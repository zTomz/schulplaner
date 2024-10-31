import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/shared/widgets/weekly_schedule/models.dart';

final weekProvider = StateProvider((ref) => Week.all);
