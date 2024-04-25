// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/user_models/user_model.dart';
import 'package:law_app/features/profile/presentation/providers/repositories_provider/profile_repository_provider.dart';

part 'profile_detail_provider.g.dart';

@riverpod
class ProfileDetail extends _$ProfileDetail {
  @override
  Future<UserModel?> build({required int id}) async {
    UserModel? user;

    state = const AsyncValue.loading();

    final result = await ref.watch(profileRepositoryProvider).getProfileDetail(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        user = r;
        state = AsyncValue.data(r);
      },
    );

    return user;
  }
}
