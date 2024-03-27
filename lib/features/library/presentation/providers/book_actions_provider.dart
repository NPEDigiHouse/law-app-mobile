// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/enums/book_file_type.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_post_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'book_actions_provider.g.dart';

@riverpod
class BookActions extends _$BookActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createBook({
    required BookPostModel book,
    required String bookPath,
    required String imagePath,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).createBook(
          book: book,
          bookPath: bookPath,
          imagePath: imagePath,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil menambahkan buku!'),
    );
  }

  Future<void> editBook({
    required BookModel book,
    String? imagePath,
    String? bookPath,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).editBook(book: book);

    final newCover = imagePath != null
        ? await ref.watch(bookRepositoryProvider).editBookFile(
              id: book.id!,
              path: imagePath,
              type: BookFileType.cover,
            )
        : null;

    final newFile = bookPath != null
        ? await ref.watch(bookRepositoryProvider).editBookFile(
              id: book.id!,
              path: bookPath,
              type: BookFileType.file,
            )
        : null;

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        if (newCover != null && newFile == null) {
          newCover.fold(
            (l) => state = AsyncValue.error(l.message, StackTrace.current),
            (r) => state = const AsyncValue.data('Berhasil mengedit buku!'),
          );
        } else if (newFile != null && newCover == null) {
          newFile.fold(
            (l) => state = AsyncValue.error(l.message, StackTrace.current),
            (r) => state = const AsyncValue.data('Berhasil mengedit buku!'),
          );
        } else if (newCover != null && newFile != null) {
          newCover.fold(
            (l) => state = AsyncValue.error(l.message, StackTrace.current),
            (r) {
              newFile.fold(
                (l) => state = AsyncValue.error(l.message, StackTrace.current),
                (r) => state = const AsyncValue.data('Berhasil mengedit buku!'),
              );
            },
          );
        } else {
          state = const AsyncValue.data('Berhasil mengedit buku!');
        }
      },
    );
  }

  Future<void> deleteBook({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).deleteBook(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil menghapus buku!'),
    );
  }
}
