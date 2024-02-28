// Package imports:
import 'package:law_app/features/admin/data/repositories/reference_repository.dart';
import 'package:law_app/features/admin/presentation/reference/providers/datasources_provider/reference_data_source_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/shared/providers/network_info_provider.dart';

part 'reference_repository_provider.g.dart';

@riverpod
ReferenceRepository referenceRepository(ReferenceRepositoryRef ref) {
  return ReferenceRepositoryImpl(
    referenceDataSource: ref.watch(referenceDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
