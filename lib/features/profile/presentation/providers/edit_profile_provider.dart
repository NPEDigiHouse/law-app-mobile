// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/user_models/user_detail_model.dart';
import 'package:law_app/features/profile/presentation/providers/repositories_provider/profile_repository_provider.dart';

part 'edit_profile_provider.g.dart';

@riverpod
class EditProfile extends _$EditProfile {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> editProfile({
    required UserDetailModel user,
    String? path,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(profileRepositoryProvider)
        .editProfile(user: user, path: path);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
