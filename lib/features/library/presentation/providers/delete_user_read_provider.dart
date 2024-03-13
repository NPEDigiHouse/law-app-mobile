// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'delete_user_read_provider.g.dart';

@riverpod
class DeleteUserRead extends _$DeleteUserRead {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> deleteUserRead({required int bookId}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(bookRepositoryProvider).deleteUserRead(bookId: bookId);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
