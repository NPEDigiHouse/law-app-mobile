// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/user_models/user_detail_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repositories_provider/master_data_repository_provider.dart';

part 'user_detail_provider.g.dart';

@riverpod
class UserDetail extends _$UserDetail {
  @override
  Future<UserDetailModel?> build({required int id}) async {
    UserDetailModel? user;

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

    return user;
  }
}
