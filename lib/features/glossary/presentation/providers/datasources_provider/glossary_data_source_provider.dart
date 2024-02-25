// Package imports:
import 'package:law_app/features/glossary/data/datasources/glossary_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/utils/http_client.dart';

part 'glossary_data_source_provider.g.dart';

@riverpod
GlossaryDataSource glossaryDataSource(GlossaryDataSourceRef ref) {
  return GlossaryDataSourceImpl(client: HttpClient.client);
}
