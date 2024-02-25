// Package imports:
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/glossary/data/datasources/glossary_data_source.dart';
import 'package:law_app/features/glossary/data/models/glossary_model.dart';
import 'package:law_app/features/shared/models/glossary_post_model.dart';

abstract class GlossaryRepository {
  /// Get glossaries
  Future<Either<Failure, List<GlossaryModel>>> getGlossaries({
    String query = '',
    int? offset,
    int? limit,
  });

  /// Get glossary detail
  Future<Either<Failure, GlossaryModel>> getGlossaryDetail({required int id});

  /// Create glossary
  Future<Either<Failure, void>> createGlossary({
    required GlossaryPostModel glossary,
  });

  /// Edit glossary
  Future<Either<Failure, void>> editGlossary({required GlossaryModel glossary});

  /// Delete glossary
  Future<Either<Failure, void>> deleteGlossary({required int id});
}

class GlossaryRepositoryImpl implements GlossaryRepository {
  final GlossaryDataSource glossaryDataSource;
  final NetworkInfo networkInfo;

  GlossaryRepositoryImpl({
    required this.glossaryDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GlossaryModel>>> getGlossaries({
    String query = '',
    int? offset,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await glossaryDataSource.getGlossaries(
          query: query,
          offset: offset,
          limit: limit,
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

  @override
  Future<Either<Failure, GlossaryModel>> getGlossaryDetail({
    required int id,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await glossaryDataSource.getGlossaryDetail(id: id);

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
  Future<Either<Failure, void>> createGlossary({
    required GlossaryPostModel glossary,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await glossaryDataSource.createGlossary(
          glossary: glossary,
        );

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case '':
            return const Left(ServerFailure(''));

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
  Future<Either<Failure, void>> editGlossary({
    required GlossaryModel glossary,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await glossaryDataSource.editGlossary(
          glossary: glossary,
        );

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case '':
            return const Left(ServerFailure(''));
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
  Future<Either<Failure, void>> deleteGlossary({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await glossaryDataSource.deleteGlossary(id: id);

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
