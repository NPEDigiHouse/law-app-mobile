// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repositories_provider/master_data_repository_provider.dart';
import 'package:law_app/features/shared/models/user_post_model.dart';

part 'create_user_provider.g.dart';

@riverpod
class CreateUser extends _$CreateUser {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createUser({required UserPostModel user}) async {
    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(masterDataRepositoryProvider).createUser(user: user);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => {},
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
