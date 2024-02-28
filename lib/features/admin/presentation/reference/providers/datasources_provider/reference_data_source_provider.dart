// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/utils/http_client.dart';
import 'package:law_app/features/admin/data/datasources/reference_data_source.dart';

part 'reference_data_source_provider.g.dart';

@riverpod
ReferenceDataSource referenceDataSource(ReferenceDataSourceRef ref) {
  return ReferenceDataSourceImpl(client: HttpClient.client);
}
