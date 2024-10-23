// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/profile/data/repositories/profile_repository.dart';
import 'package:law_app/features/profile/presentation/providers/datasources_provider/profile_data_source_provider.dart';
import 'package:law_app/features/shared/providers/generated_providers/network_info_provider.dart';

part 'profile_repository_provider.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(
    profileDataSource: ref.watch(profileDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
