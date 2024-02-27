// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/profile/presentation/providers/repositories_provider/profile_repository_provider.dart';

part 'change_password_provider.g.dart';

@riverpod
class ChangePassword extends _$ChangePassword {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(profileRepositoryProvider).changePassword(
            email: email,
            currentPassword: currentPassword,
            newPassword: newPassword,
          );

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => state = const AsyncValue.data(true),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
