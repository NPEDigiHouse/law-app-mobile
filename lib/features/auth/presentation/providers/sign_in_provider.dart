// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/user_models/user_credential_model.dart';
import 'package:law_app/features/auth/presentation/providers/repositories_provider/auth_repository_provider.dart';
import 'package:law_app/features/auth/presentation/providers/user_credential_provider.dart';

part 'sign_in_provider.g.dart';

@riverpod
class SignIn extends _$SignIn {
  @override
  AsyncValue<(bool?, UserCredentialModel?)> build() {
    return const AsyncValue.data((null, null));
  }

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(authRepositoryProvider).signIn(
          username: username,
          password: password,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        if (r) {
          ref.listen(userCredentialProvider, (_, state) {
            state.whenOrNull(
              error: (error, _) {
                this.state = AsyncValue.error(
                  (error as Failure).message,
                  StackTrace.current,
                );
              },
              data: (data) {
                this.state = AsyncValue.data((r, data));
              },
            );
          });
        }
      },
    );
  }
}
