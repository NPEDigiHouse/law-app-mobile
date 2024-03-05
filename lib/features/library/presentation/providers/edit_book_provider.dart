// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/enums/book_file_type.dart';
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'edit_book_provider.g.dart';

@riverpod
class EditBook extends _$EditBook {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> editBook({
    required BookDetailModel book,
    String? coverPath,
    String? filePath,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).editBook(book: book);

    final newCover = coverPath != null
        ? await ref.watch(bookRepositoryProvider).editBookFile(
              id: book.id!,
              path: coverPath,
              type: BookFileType.cover,
            )
        : null;

    final newFile = filePath != null
        ? await ref.watch(bookRepositoryProvider).editBookFile(
              id: book.id!,
              path: filePath,
              type: BookFileType.file,
            )
        : null;

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        if (newCover != null && newFile == null) {
          newCover.fold(
            (l) => state = AsyncValue.error(l.message, StackTrace.current),
            (r) => state = const AsyncValue.data(true),
          );
        } else if (newFile != null && newCover == null) {
          newFile.fold(
            (l) => state = AsyncValue.error(l.message, StackTrace.current),
            (r) => state = const AsyncValue.data(true),
          );
        } else if (newCover != null && newFile != null) {
          newCover.fold(
            (l) => state = AsyncValue.error(l.message, StackTrace.current),
            (r) {
              newFile.fold(
                (l) => state = AsyncValue.error(l.message, StackTrace.current),
                (r) => state = const AsyncValue.data(true),
              );
            },
          );
        } else {
          state = const AsyncValue.data(true);
        }
      },
    );
  }
}
