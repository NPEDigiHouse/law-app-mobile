// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'create_user_read_provider.g.dart';

@riverpod
class CreateUserRead extends _$CreateUserRead {
  @override
  Future<bool?> build({required int bookId}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(bookRepositoryProvider).createUserRead(bookId: bookId);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );

    return null;
  }
}
