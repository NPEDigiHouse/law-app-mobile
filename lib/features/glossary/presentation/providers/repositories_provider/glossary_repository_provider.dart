// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/repositories/glossary_repository.dart';
import 'package:law_app/features/glossary/presentation/providers/datasources_provider/glossary_data_source_provider.dart';
import 'package:law_app/features/shared/providers/generated_providers/network_info_provider.dart';

part 'glossary_repository_provider.g.dart';

@riverpod
GlossaryRepository glossaryRepository(Ref ref) {
  return GlossaryRepositoryImpl(
    glossaryDataSource: ref.watch(glossaryDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
