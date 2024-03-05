// Package imports:
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_book_provider.g.dart';

@riverpod
class EditBook extends _$EditBook {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> editBook({required BookDetailModel book}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).editBook(book: book);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
