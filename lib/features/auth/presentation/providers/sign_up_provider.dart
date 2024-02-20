import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/auth/data/models/user_register_model.dart';
import 'package:law_app/features/auth/presentation/providers/auth_repository_provider.dart';

part 'sign_up_provider.g.dart';

@riverpod
class SignUp extends _$SignUp {
  Failure? _failure;
  bool? _success;

  @override
  ({Failure? failure, bool? success}) build() {
    return (failure: _failure, success: _success);
  }

  Future<void> signUp({required UserSignUpModel userSignUpModel}) async {
    final result = await ref.watch(authRepositoryProvider).signUp(
          userSignUpModel: userSignUpModel,
        );

    result.fold(
      (l) => _failure = l,
      (r) => _success = r,
    );
  }
}
