// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/auth/presentation/providers/auth_repository_provider.dart';

part 'log_out_provider.g.dart';

@riverpod
class LogOut extends _$LogOut {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> logOut() async {
    bool? success;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(authRepositoryProvider).logOut();

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
