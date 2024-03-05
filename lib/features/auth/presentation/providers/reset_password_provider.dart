// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/auth/presentation/providers/repositories_provider/auth_repository_provider.dart';

part 'reset_password_provider.g.dart';

@riverpod
class ResetPassword extends _$ResetPassword {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> resetPassword({
    required String email,
    required String resetPasswordToken,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(authRepositoryProvider).resetPassword(
          email: email,
          resetPasswordToken: resetPasswordToken,
          newPassword: newPassword,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }
}
