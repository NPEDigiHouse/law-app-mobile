// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/models/user_models/user_model.dart';
import 'package:law_app/features/profile/data/datasources/profile_data_source.dart';

abstract class ProfileRepository {
  /// Get profile detail
  Future<Either<Failure, UserModel>> getProfileDetail({required int id});

  /// Edit profile
  Future<Either<Failure, void>> editProfile({
    required UserModel user,
    String? path,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  });
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource profileDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.profileDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserModel>> getProfileDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await profileDataSource.getProfileDetail(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editProfile({
    required UserModel user,
    String? path,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await profileDataSource.editProfile(
          user: user,
          path: path,
        );

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await profileDataSource.changePassword(
          email: email,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
