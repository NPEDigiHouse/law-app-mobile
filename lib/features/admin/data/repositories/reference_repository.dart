// Package imports:
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/reference_data_source.dart';
import 'package:law_app/features/admin/data/models/discussion_category_model.dart';

abstract class ReferenceRepository {
  /// Get discussion categories
  Future<Either<Failure, List<DiscussionCategoryModel>>>
      getDiscussionCategories();

  /// Create discussion categories
  Future<Either<Failure, void>> createDiscussionCategory(
      {required String name});

  /// Edit discussion categories
  Future<Either<Failure, void>> editDiscussionCategory(
      {required DiscussionCategoryModel category});

  /// Delete discussion categories
  Future<Either<Failure, void>> deleteDiscussionCategory({required int id});
}

class ReferenceRepositoryImpl implements ReferenceRepository {
  final ReferenceDataSource referenceDataSource;
  final NetworkInfo networkInfo;

  ReferenceRepositoryImpl({
    required this.referenceDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DiscussionCategoryModel>>>
      getDiscussionCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.getDiscussionCategories();

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
  Future<Either<Failure, void>> createDiscussionCategory(
      {required String name}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await referenceDataSource.createDiscussionCategory(name: name);

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kCategoryAlreadyExist:
            return const Left(ServerFailure('Kategori sudah ada'));
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
  Future<Either<Failure, void>> editDiscussionCategory(
      {required DiscussionCategoryModel category}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.editDiscussionCategory(
            category: category);

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kCategoryAlreadyExist:
            return const Left(ServerFailure('Kategori sudah ada'));
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
  Future<Either<Failure, void>> deleteDiscussionCategory(
      {required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await referenceDataSource.deleteDiscussionCategory(id: id);

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
