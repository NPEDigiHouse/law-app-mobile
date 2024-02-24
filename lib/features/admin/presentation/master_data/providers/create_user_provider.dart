// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repository_provider/master_data_repository_provider.dart';
import 'package:law_app/features/shared/models/user_post_model.dart';

part 'create_user_provider.g.dart';

@riverpod
class CreateUser extends _$CreateUser {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.loading();
  }

  Future<void> createUser({required UserPostModel userPostModel}) async {
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(masterDataRepositoryProvider)
          .createUser(userPostModel: userPostModel);

      result.fold(
        (l) => failure = l,
        (r) => {},
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (failure != null) {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      } else {
        state = const AsyncValue.data(null);
      }
    }
  }
}
