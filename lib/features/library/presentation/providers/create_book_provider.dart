// Package imports:
import 'package:law_app/features/admin/data/models/book_models/book_post_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_book_provider.g.dart';

@riverpod
class CreateBook extends _$CreateBook {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createBook({required BookPostModel book}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(bookRepositoryProvider).createBook(book: book);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
