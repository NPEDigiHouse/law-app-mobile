// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/book_models/book_saved_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'book_saved_provider.g.dart';

@riverpod
class BookSaved extends _$BookSaved {
  @override
  Future<List<BookSavedModel>?> build({required int userId}) async {
    List<BookSavedModel>? books;

    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).getSavedBooks(userId: userId);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        books = r;
        state = AsyncValue.data(r);
      },
    );

    return books;
  }
}
