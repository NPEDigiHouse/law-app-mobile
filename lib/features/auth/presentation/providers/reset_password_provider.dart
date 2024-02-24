// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/auth/presentation/providers/repository_provider/auth_repository_provider.dart';

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
    bool? success;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(authRepositoryProvider).resetPassword(
            email: email,
            resetPasswordToken: resetPasswordToken,
            newPassword: newPassword,
          );

      result.fold(
        (l) => failure = l,
        (r) => success = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (success != null) {
        state = AsyncValue.data(success);
      } else {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }
  }
}
