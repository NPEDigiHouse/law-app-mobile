// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/repositories/master_data_repository.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/datasources_provider/master_data_source_provider.dart';
import 'package:law_app/features/shared/providers/generated_providers/network_info_provider.dart';

part 'master_data_repository_provider.g.dart';

@riverpod
MasterDataRepository masterDataRepository(Ref ref) {
  return MasterDataRepositoryImpl(
    masterDataSource: ref.watch(masterDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
