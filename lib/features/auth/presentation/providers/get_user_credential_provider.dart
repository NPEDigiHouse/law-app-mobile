// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/auth/data/models/user_credential_model.dart';
import 'package:law_app/features/auth/presentation/providers/repositories_provider/auth_repository_provider.dart';

part 'get_user_credential_provider.g.dart';

@riverpod
class GetUserCredential extends _$GetUserCredential {
  @override
  Future<UserCredentialModel?> build() async {
    UserCredentialModel? userCredential;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(authRepositoryProvider).getUserCredential();

      result.fold(
        (l) => failure = l,
        (r) => userCredential = r,
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      if (userCredential != null) {
        state = AsyncValue.data(userCredential);
      } else {
        state = AsyncValue.error(failure!, StackTrace.current);
      }
    }

    return userCredential;
  }
}
