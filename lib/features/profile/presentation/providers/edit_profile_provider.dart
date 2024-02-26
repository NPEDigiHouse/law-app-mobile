// Package imports:
import 'package:law_app/features/profile/presentation/providers/repositories_provider/profile_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/shared/models/user_model.dart';

part 'edit_profile_provider.g.dart';

@riverpod
class EditProfile extends _$EditProfile {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> editProfile({required UserModel user, String? path}) async {
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(profileRepositoryProvider)
          .editProfile(user: user, path: path);

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
