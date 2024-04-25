// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/master_data_source.dart';
import 'package:law_app/features/admin/data/models/user_models/user_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_post_model.dart';

abstract class MasterDataRepository {
  /// Get Users
  Future<Either<Failure, List<UserModel>>> getUsers({
    String query = '',
    String sortBy = '',
    String sortOrder = '',
    String role = '',
  });

  /// Get user detail
  Future<Either<Failure, UserModel>> getUserDetail({required int id});

  /// Create user
  Future<Either<Failure, void>> createUser({required UserPostModel user});

  /// Edit user
  Future<Either<Failure, void>> editUser({required UserModel user});

  /// Delete user
  Future<Either<Failure, void>> deleteUser({required int id});
}

class MasterDataRepositoryImpl implements MasterDataRepository {
  final MasterDataSource masterDataSource;
  final NetworkInfo networkInfo;

  MasterDataRepositoryImpl({
    required this.masterDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<UserModel>>> getUsers({
    String query = '',
    String sortBy = '',
    String sortOrder = '',
    String role = '',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await masterDataSource.getUsers(
          query: query,
          sortBy: sortBy,
          sortOrder: sortOrder,
          role: role,
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
  Future<Either<Failure, UserModel>> getUserDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await masterDataSource.getUserDetail(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createUser({required UserPostModel user}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await masterDataSource.createUser(user: user);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editUser({required UserModel user}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await masterDataSource.editUser(user: user);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await masterDataSource.deleteUser(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
