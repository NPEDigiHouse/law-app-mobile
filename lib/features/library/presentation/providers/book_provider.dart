// Package imports:
import 'package:law_app/core/utils/const.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'book_provider.g.dart';

@riverpod
class Book extends _$Book {
  @override
  Future<({List<BookModel>? books, bool? hasMore})> build({
    String query = '',
    int? categoryId,
  }) async {
    List<BookModel>? books;
    bool? hasMore;

    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).getBooks(
          query: query,
          categoryId: categoryId,
          offset: 0,
          limit: kPageLimit,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        books = r;
        hasMore = r.length == kPageLimit;

        state = AsyncValue.data((books: books, hasMore: hasMore));
      },
    );

    return (books: books, hasMore: hasMore);
  }

  Future<void> fetchMoreBooks({
    String query = '',
    int? categoryId,
    required int offset,
  }) async {
    final result = await ref.watch(bookRepositoryProvider).getBooks(
          query: query,
          categoryId: categoryId,
          offset: offset,
          limit: kPageLimit,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        final previousState = state.valueOrNull;

        if (previousState != null) {
          state = AsyncValue.data((
            books: [...previousState.books!, ...r],
            hasMore: r.length == kPageLimit,
          ));
        }
      },
    );
  }
}
