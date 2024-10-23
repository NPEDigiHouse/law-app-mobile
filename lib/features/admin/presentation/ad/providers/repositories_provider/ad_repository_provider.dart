// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/repositories/ad_repository.dart';
import 'package:law_app/features/admin/presentation/ad/providers/datasources_provider/ad_data_source_provider.dart';
import 'package:law_app/features/shared/providers/generated_providers/network_info_provider.dart';

part 'ad_repository_provider.g.dart';

@riverpod
AdRepository adRepository(Ref ref) {
  return AdRepositoryImpl(
    adDataSource: ref.watch(adDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
