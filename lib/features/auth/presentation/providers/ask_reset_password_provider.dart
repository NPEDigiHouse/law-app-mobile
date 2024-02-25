// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/auth/presentation/providers/repositories_provider/auth_repository_provider.dart';

part 'ask_reset_password_provider.g.dart';

@riverpod
class AskResetPassword extends _$AskResetPassword {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> askResetPassword({required String email}) async {
    String? otp;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(authRepositoryProvider)
          .askResetPassword(email: email);

      result.fold(
        (l) => failure = l,
        (r) => otp = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (otp != null) {
        state = AsyncValue.data(otp);
      } else {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }
  }
}
