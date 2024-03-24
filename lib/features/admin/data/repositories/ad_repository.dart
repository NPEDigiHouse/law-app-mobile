// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/ad_data_source.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_detail_model.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_model.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_post_model.dart';

abstract class AdRepository {
  /// Get ads
  Future<Either<Failure, List<AdModel>>> getAds();

  /// Get ad detail
  Future<Either<Failure, AdDetailModel>> getAdDetail({required int id});

  /// Create ad
  Future<Either<Failure, void>> createAd({required AdPostModel ad});

  /// Edit ad
  Future<Either<Failure, void>> editAd({required AdDetailModel ad});

  /// Delete ad
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, AdDetailModel>> getAdDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await adDataSource.getAdDetail(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createAd({required AdPostModel ad}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await adDataSource.createAd(ad: ad);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editAd({required AdDetailModel ad}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await adDataSource.editAd(ad: ad);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
