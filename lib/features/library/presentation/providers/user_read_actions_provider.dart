// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'user_read_actions_provider.g.dart';

@riverpod
class UserReadActions extends _$UserReadActions {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> updateUserRead({
    required int bookId,
    required int currentPage,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).updateUserRead(
          bookId: bookId,
          currentPage: currentPage,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }

  Future<void> deleteUserRead({required int bookId}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).deleteUserRead(bookId: bookId);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
