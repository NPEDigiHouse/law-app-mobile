import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/auth/data/models/user_credential_model.dart';
import 'package:law_app/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:law_app/features/auth/presentation/providers/get_user_credential_provider.dart';

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
    bool? success;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(authRepositoryProvider).signIn(
            username: username,
            password: password,
          );

      result.fold(
        (l) => failure = l,
        (r) {
          success = r;

          if (r) {
            ref.listen(getUserCredentialProvider, (_, state) {
              return state.whenOrNull(
                error: (error, _) {
                  this.state = AsyncValue.error(
                    (error as Failure).message,
                    StackTrace.current,
                  );
                },
                data: (data) {
                  this.state = AsyncValue.data((success, data));
                },
              );
            });
          }
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (failure != null) {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }
  }
}
