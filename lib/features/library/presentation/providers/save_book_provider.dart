// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'save_book_provider.g.dart';

@riverpod
class SaveBook extends _$SaveBook {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> saveBook({required int bookId}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(bookRepositoryProvider).saveBook(bookId: bookId);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
