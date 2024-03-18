// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/user_models/user_detail_model.dart';
import 'package:law_app/features/profile/presentation/providers/repositories_provider/profile_repository_provider.dart';

part 'profile_actions_provider.g.dart';

@riverpod
class ProfileActions extends _$ProfileActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> editProfile({
    required UserDetailModel user,
    String? path,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(profileRepositoryProvider)
        .editProfile(user: user, path: path);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil mengedit profile!'),
    );
  }

  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).changePassword(
          email: email,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Password berhasil diubah!'),
    );
  }
}
