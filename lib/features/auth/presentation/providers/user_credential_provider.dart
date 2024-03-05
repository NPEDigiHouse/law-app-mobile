// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/user_models/user_credential_model.dart';
import 'package:law_app/features/auth/presentation/providers/repositories_provider/auth_repository_provider.dart';

part 'user_credential_provider.g.dart';

@riverpod
class UserCredential extends _$UserCredential {
  @override
  Future<UserCredentialModel?> build() async {
    UserCredentialModel? userCredential;

    state = const AsyncValue.loading();

    final result = await ref.watch(authRepositoryProvider).getUserCredential();

    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) {
        userCredential = r;
        state = AsyncValue.data(r);
      },
    );

    return userCredential;
  }
}
