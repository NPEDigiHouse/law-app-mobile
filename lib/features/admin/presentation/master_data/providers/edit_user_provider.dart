// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repository_provider/master_data_repository_provider.dart';

part 'edit_user_provider.g.dart';

@riverpod
class EditUser extends _$EditUser {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.loading();
  }

  Future<void> editUser({
    required int id,
    String? name,
    String? email,
    String? birthDate,
    String? phoneNumber,
  }) async {
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(masterDataRepositoryProvider).editUser(
            id: id,
            name: name,
            email: email,
            birthDate: birthDate,
            phoneNumber: phoneNumber,
          );

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
