// Package imports:
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:law_app/features/auth/data/models/user_credential_model.dart';
import 'package:law_app/features/shared/models/user_post_model.dart';

abstract class AuthRepository {
  /// Sign Up
  Future<Either<Failure, bool>> signUp({
    required UserPostModel userPostModel,
  });

  /// Sign In
  Future<Either<Failure, bool>> signIn({
    required String username,
    required String password,
  });

  // Is Sign in
  Future<Either<Failure, bool>> isSignIn();

  /// Get user credential
  Future<Either<Failure, UserCredentialModel>> getUserCredential();

  /// Log out
  Future<Either<Failure, bool>> logOut();

  /// Ask reset password
  Future<Either<Failure, String>> askResetPassword({required String email});

  /// Reset password
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String resetPasswordToken,
    required String newPassword,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.authDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> signUp({
    required UserPostModel userPostModel,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await authDataSource.signUp(
          userPostModel: userPostModel,
        );

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kUsernameAlreadyExist:
            return const Left(ServerFailure('Username telah digunakan'));
          case kEmailAlreadyExist:
            return const Left(ServerFailure('Email telah digunakan'));
          default:
            return Left(ServerFailure(e.message));
        }
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, bool>> signIn({
    required String username,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await authDataSource.signIn(
          username: username,
          password: password,
        );

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kUserNotFound:
            return const Left(ServerFailure('Akun belum terdaftar'));
          case kWrongPassword:
            return const Left(ServerFailure('Password salah'));
          default:
            return Left(ServerFailure(e.message));
        }
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignIn() async {
    try {
      final result = await authDataSource.isSignIn();

      return Right(result);
    } on PreferenceException catch (e) {
      return Left(PreferenceFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserCredentialModel>> getUserCredential() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await authDataSource.getUserCredential();

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      final result = await authDataSource.logOut();

      return Right(result);
    } on PreferenceException catch (e) {
      return Left(PreferenceFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> askResetPassword({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await authDataSource.askResetPassword(email: email);

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kUserNotFound:
            return const Left(ServerFailure('Email tidak terdaftar'));
          default:
            return Left(ServerFailure(e.message));
        }
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String resetPasswordToken,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await authDataSource.resetPassword(
          email: email,
          resetPasswordToken: resetPasswordToken,
          newPassword: newPassword,
        );

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
