// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/user_models/user_detail_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repositories_provider/master_data_repository_provider.dart';

part 'edit_user_provider.g.dart';

@riverpod
class EditUser extends _$EditUser {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> editUser({required UserDetailModel user}) async {
    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(masterDataRepositoryProvider).editUser(user: user);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => state = const AsyncValue.data(true),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
