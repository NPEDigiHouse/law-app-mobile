// Package imports:
import 'package:law_app/features/profile/presentation/providers/repositories_provider/profile_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/shared/models/user_model.dart';

part 'get_profile_detail_provider.g.dart';

@riverpod
class GetProfileDetail extends _$GetProfileDetail {
  @override
  Future<UserModel?> build({required int id}) async {
    UserModel? user;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(profileRepositoryProvider).getProfileDetail(id: id);

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
