import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/auth/presentation/providers/auth_repository_provider.dart';

part 'is_sign_in_provider.g.dart';

@riverpod
class IsSignIn extends _$IsSignIn {
  @override
  Future<bool?> build() async {
    bool? success;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(authRepositoryProvider).isSignIn();

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

    return success;
  }
}
