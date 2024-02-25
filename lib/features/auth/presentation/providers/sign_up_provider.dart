// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/auth/presentation/providers/repositories_provider/auth_repository_provider.dart';
import 'package:law_app/features/shared/models/user_post_model.dart';

part 'sign_up_provider.g.dart';

@riverpod
class SignUp extends _$SignUp {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> signUp({required UserPostModel userPostModel}) async {
    bool? success;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(authRepositoryProvider)
          .signUp(userPostModel: userPostModel);

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
