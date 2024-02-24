// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/user_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/repository_provider/master_data_repository_provider.dart';
import 'package:law_app/features/shared/models/user_post_model.dart';

part 'master_data_provider.g.dart';

@riverpod
class MasterData extends _$MasterData {
  @override
  Future<List<UserModel>?> build() async {
    List<UserModel>? users;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(masterDataRepositoryProvider).getUsers();

      result.fold(
        (l) => failure = l,
        (r) => users = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (users != null) {
        state = AsyncValue.data(users);
      } else {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }

    return users;
  }

  Future<void> searchUsers({String query = ''}) async {
    List<UserModel>? users;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(masterDataRepositoryProvider).getUsers(
            query: query,
          );

      result.fold(
        (l) => failure = l,
        (r) => users = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (users != null) {
        state = AsyncValue.data(users);
      } else {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }
  }

  Future<void> sortUsers({String sortBy = '', String sortOrder = ''}) async {
    List<UserModel>? users;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(masterDataRepositoryProvider).getUsers(
            sortBy: sortBy,
            sortOrder: sortOrder,
          );

      result.fold(
        (l) => failure = l,
        (r) => users = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (users != null) {
        state = AsyncValue.data(users);
      } else {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }
  }

  Future<void> filterUsers({String? role}) async {
    List<UserModel>? users;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(masterDataRepositoryProvider).getUsers(
            role: role,
          );

      result.fold(
        (l) => failure = l,
        (r) => users = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (users != null) {
        state = AsyncValue.data(users);
      } else {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }
  }

  Future<void> deleteUser({required int id}) async {
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(masterDataRepositoryProvider).deleteUser(
            id: id,
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
        ref.invalidateSelf();
      }
    }
  }

  Future<void> createUser({required UserPostModel userPostModel}) async {
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(masterDataRepositoryProvider).createUser(
            userPostModel: userPostModel,
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
        ref.invalidateSelf();
      }
    }
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
        ref.invalidateSelf();
      }
    }
  }
}
