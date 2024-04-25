// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_saved_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'book_detail_provider.g.dart';

@riverpod
class BookDetail extends _$BookDetail {
  @override
  Future<({BookModel? book, BookSavedModel? savedBook})> build({required int id}) async {
    BookModel? book;
    BookSavedModel? savedBook;

    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).getBookDetail(id: id);

    final result2 =
        await ref.watch(bookRepositoryProvider).getSavedBooks(userId: CredentialSaver.user!.id!);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        book = r;

        result2.fold(
          (l) => state = AsyncValue.error(l.message, StackTrace.current),
          (r) {
            final books = r.where((e) => e.book!.id == book!.id).toList();

            savedBook = books.isEmpty ? null : books.first;

            state = AsyncValue.data((book: book, savedBook: savedBook));
          },
        );
      },
    );

    return (book: book, savedBook: savedBook);
  }
}
