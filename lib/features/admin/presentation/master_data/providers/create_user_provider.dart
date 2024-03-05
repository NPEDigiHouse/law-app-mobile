// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/user_models/user_post_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repositories_provider/master_data_repository_provider.dart';

part 'create_user_provider.g.dart';

@riverpod
class CreateUser extends _$CreateUser {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createUser({required UserPostModel user}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(masterDataRepositoryProvider).createUser(user: user);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
