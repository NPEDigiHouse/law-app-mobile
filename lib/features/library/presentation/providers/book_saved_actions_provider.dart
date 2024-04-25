// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'book_saved_actions_provider.g.dart';

@riverpod
class BookSavedActions extends _$BookSavedActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> saveBook({required int bookId}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).saveBook(bookId: bookId);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(
        'Buku dimasukkan ke daftar buku disimpan!',
      ),
    );
  }

  Future<void> unsaveBook({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).unsaveBook(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(
        'Buku dikeluarkan dari daftar buku disimpan!',
      ),
    );
  }
}
