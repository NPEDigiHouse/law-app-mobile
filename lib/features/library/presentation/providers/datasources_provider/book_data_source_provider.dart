// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/utils/http_client.dart';
import 'package:law_app/features/admin/data/datasources/book_data_source.dart';

part 'book_data_source_provider.g.dart';

@riverpod
BookDataSource bookDataSource(Ref ref) {
  return BookDataSourceImpl(client: HttpClient.client);
}
