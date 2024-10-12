import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:schulplaner/features/auth/data/data_source/auth_data_source.dart';
import 'package:schulplaner/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:schulplaner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:schulplaner/features/auth/domain/repositories/auth_repository.dart';

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return AuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);

  return AuthRepositoryImpl(dataSource: dataSource);
});
