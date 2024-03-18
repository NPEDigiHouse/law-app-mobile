// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/user_models/user_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repositories_provider/master_data_repository_provider.dart';

part 'master_data_provider.g.dart';

@riverpod
class MasterData extends _$MasterData {
  @override
  Future<List<UserModel>?> build() async {
    List<UserModel>? users;

    state = const AsyncValue.loading();

    final result = await ref.watch(masterDataRepositoryProvider).getUsers();

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        users = r;
        state = AsyncValue.data(r);
      },
    );

    return users;
  }

  Future<void> searchUsers({String query = ''}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(masterDataRepositoryProvider).getUsers(query: query);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }

  Future<void> sortUsers({String sortBy = '', String sortOrder = ''}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(masterDataRepositoryProvider).getUsers(
          sortBy: sortBy,
          sortOrder: sortOrder,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }

  Future<void> filterUsers({String role = ''}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(masterDataRepositoryProvider).getUsers(role: role);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }
}
