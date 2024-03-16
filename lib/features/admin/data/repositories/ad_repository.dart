// Package imports:
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/ad_data_source.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_model.dart';

abstract class AdRepository {
  /// Get ads
  Future<Either<Failure, List<AdModel>>> getAds();

  /// Get ad detail
  Future<Either<Failure, AdModel>> getAdDetail({required int id});

  /// Create ads
  Future<Either<Failure, void>> createAd({
    required String title,
    required String content,
    required String imageName,
  });

  /// Edit ads
  Future<Either<Failure, void>> editAd({required AdModel ad});

  /// Delete ads
  Future<Either<Failure, void>> deleteAd({required int id});
}

class AdRepositoryImpl implements AdRepository {
  final AdDataSource adDataSource;
  final NetworkInfo networkInfo;

  AdRepositoryImpl({
    required this.adDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AdModel>>> getAds() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await adDataSource.getAds();

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
  Future<Either<Failure, AdModel>> getAdDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await adDataSource.getAdDetail(id: id);

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
  Future<Either<Failure, void>> createAd({
    required String title,
    required String content,
    required String imageName,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await adDataSource.createAd(
          title: title,
          content: content,
          imageName: imageName,
        );

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kAdsTitleAlreadyExist:
            return const Left(
              ServerFailure('Telah ada Ad dengan judul yang sama'),
            );
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
  Future<Either<Failure, void>> deleteAd({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await adDataSource.deleteAd(id: id);

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
  Future<Either<Failure, void>> editAd({required AdModel ad}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await adDataSource.editAd(ad: ad);

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
