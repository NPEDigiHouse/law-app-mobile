// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'library_provider.g.dart';

@riverpod
class Library extends _$Library {
  @override
  Future<({List<BookModel>? books, List<BookModel>? userReads})> build() async {
    List<BookModel>? books;
    List<BookModel>? userReads;

    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).getBooks(limit: kPageLimit);

    final result2 = await ref.watch(bookRepositoryProvider).getUserReads(isFinished: false);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        books = r;

        result2.fold(
          (l) => state = AsyncValue.error(l.message, StackTrace.current),
          (r) {
            userReads = r;
            state = AsyncValue.data((books: books, userReads: userReads));
          },
        );
      },
    );

    return (books: books, userReads: userReads);
  }
}
