// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/auth/data/repositories/auth_repository.dart';
import 'package:law_app/features/auth/presentation/providers/datasources_provider/auth_data_source_provider.dart';
import 'package:law_app/features/shared/providers/generated_providers/network_info_provider.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    authDataSource: ref.watch(authDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
