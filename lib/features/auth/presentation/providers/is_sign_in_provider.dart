// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/auth/data/models/user_credential_model.dart';
import 'package:law_app/features/auth/presentation/providers/get_user_credential_provider.dart';
import 'package:law_app/features/auth/presentation/providers/repositories_provider/auth_repository_provider.dart';

part 'is_sign_in_provider.g.dart';

@riverpod
class IsSignIn extends _$IsSignIn {
  @override
  Future<(bool?, UserCredentialModel?)> build() async {
    bool? isSignIn;
    UserCredentialModel? userCredential;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(authRepositoryProvider).isSignIn();

      result.fold(
        (l) => failure = l,
        (r) {
          isSignIn = r;

          if (r) {
            ref.listen(getUserCredentialProvider, (_, state) {
              state.whenOrNull(
                error: (error, _) {
                  this.state = AsyncValue.error(
                    (error as Failure).message,
                    StackTrace.current,
                  );
                },
                data: (data) {
                  this.state = AsyncValue.data((isSignIn, data));
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

    return (isSignIn, userCredential);
  }
}
