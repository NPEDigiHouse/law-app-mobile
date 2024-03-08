// Package imports:
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_book_provider.g.dart';

@riverpod
class SaveBook extends _$SaveBook {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> saveBook({
    required int userId,
    required int bookId,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).saveBook(
          userId: userId,
          bookId: bookId,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }

  Future<void> unsaveBook({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).unsaveBook(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
