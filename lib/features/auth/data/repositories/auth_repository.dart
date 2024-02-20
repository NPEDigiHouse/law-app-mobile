import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:law_app/features/auth/data/models/user_register_model.dart';

abstract class AuthRepository {
  // Sign Up
  Future<Either<Failure, bool>> signUp({
    required UserSignUpModel userSignUpModel,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> signUp({
    required UserSignUpModel userSignUpModel,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await authRemoteDataSource.signUp(
          userSignUpModel: userSignUpModel,
        );

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('no_internet_connection'));
    }
  }
}
