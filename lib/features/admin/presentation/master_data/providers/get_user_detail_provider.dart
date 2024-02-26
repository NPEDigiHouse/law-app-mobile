// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repositories_provider/master_data_repository_provider.dart';
import 'package:law_app/features/shared/models/user_model.dart';

part 'get_user_detail_provider.g.dart';

@riverpod
class GetUserDetail extends _$GetUserDetail {
  @override
  Future<UserModel?> build({required int id}) async {
    UserModel? user;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(masterDataRepositoryProvider).getUserDetail(id: id);

      result.fold(
        (l) => failure = l,
        (r) => user = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }

    return user;
  }
}
