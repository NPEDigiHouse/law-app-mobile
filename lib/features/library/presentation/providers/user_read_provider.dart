// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'user_read_provider.g.dart';

@riverpod
class UserRead extends _$UserRead {
  @override
  Future<List<BookModel>?> build() async {
    List<BookModel>? books;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(bookRepositoryProvider).getUserReads(isFinished: true);

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
