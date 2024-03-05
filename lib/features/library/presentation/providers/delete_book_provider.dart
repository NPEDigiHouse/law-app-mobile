// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'delete_book_provider.g.dart';

@riverpod
class DeleteBook extends _$DeleteBook {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> deleteBook({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).deleteBook(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
