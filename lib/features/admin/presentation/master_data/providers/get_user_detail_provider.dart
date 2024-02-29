// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/user_models/user_detail_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repositories_provider/master_data_repository_provider.dart';

part 'get_user_detail_provider.g.dart';

@riverpod
class GetUserDetail extends _$GetUserDetail {
  @override
  Future<UserDetailModel?> build({required int id}) async {
    UserDetailModel? user;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(masterDataRepositoryProvider).getUserDetail(id: id);

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
