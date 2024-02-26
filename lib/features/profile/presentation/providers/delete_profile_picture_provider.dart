// Package imports:
import 'package:law_app/features/profile/presentation/providers/repositories_provider/profile_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/shared/models/user_model.dart';

part 'delete_profile_picture_provider.g.dart';

@riverpod
class DeleteProfilePicture extends _$DeleteProfilePicture {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> deleteProfilePicture({required UserModel user}) async {
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(profileRepositoryProvider)
          .deleteProfilePicture(user: user);

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
        state = const AsyncValue.data(true);
      }
    }
  }
}
