// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/auth/data/repositories/auth_repository.dart';
import 'package:law_app/features/auth/presentation/providers/auth_remote_data_source_provider.dart';
import 'package:law_app/features/shared/providers/network_info_provider.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    authRemoteDataSource: ref.watch(authRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
