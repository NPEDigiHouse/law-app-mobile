// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/repositories/book_repository.dart';
import 'package:law_app/features/library/presentation/providers/datasources_provider/book_data_source_provider.dart';
import 'package:law_app/features/shared/providers/network_info_provider.dart';

part 'book_repository_provider.g.dart';

@riverpod
BookRepository bookRepository(BookRepositoryRef ref) {
  return BookRepositoryImpl(
    bookDataSource: ref.watch(bookDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
