// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'unsave_book_provider.g.dart';

@riverpod
class UnsaveBook extends _$UnsaveBook {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
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
