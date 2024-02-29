// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/user_models/user_detail_model.dart';
import 'package:law_app/features/profile/presentation/providers/repositories_provider/profile_repository_provider.dart';

part 'get_profile_detail_provider.g.dart';

@riverpod
class GetProfileDetail extends _$GetProfileDetail {
  @override
  Future<UserDetailModel?> build({required int id}) async {
    UserDetailModel? user;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(profileRepositoryProvider).getProfileDetail(id: id);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) {
          user = r;
          state = AsyncValue.data(r);
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return user;
  }
}
