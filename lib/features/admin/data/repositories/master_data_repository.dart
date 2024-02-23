// Package imports:
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/master_data_source.dart';
import 'package:law_app/features/admin/data/models/user_model.dart';

abstract class MasterDataRepository {
  /// Get Users
  Future<Either<Failure, List<UserModel>>> getUsers([
    String query = '',
    String sortBy = '',
    String sortOrder = '',
  ]);
}

class MasterDataRepositoryImpl implements MasterDataRepository {
  final MasterDataSource masterDataSource;
  final NetworkInfo networkInfo;

  MasterDataRepositoryImpl({
    required this.masterDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<UserModel>>> getUsers([
    String query = '',
    String sortBy = '',
    String sortOrder = '',
  ]) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await masterDataSource.getUsers(
          query,
          sortBy,
          sortOrder,
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
