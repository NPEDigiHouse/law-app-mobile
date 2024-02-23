// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/user_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repository_provider/master_data_repository_provider.dart';

part 'master_data_provider.g.dart';

@riverpod
class MasterData extends _$MasterData {
  @override
  Future<List<UserModel>?> build() async {
    List<UserModel>? users;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(masterDataRepositoryProvider).getUsers();

      result.fold(
        (l) => failure = l,
        (r) => users = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (users != null) {
        state = AsyncValue.data(users);
      } else {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }

    return users;
  }
}
