// Package imports:
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/discussion_data_source.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_detail_model.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_post_model.dart';

abstract class DiscussionRepository {
  /// Get user discussions
  Future<Either<Failure, List<DiscussionModel>>> getUserDiscussions({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  });

  /// Get all discussions
  Future<Either<Failure, List<DiscussionModel>>> getDiscussions({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  });

  /// Get discussion detail
  Future<Either<Failure, DiscussionDetailModel>> getDiscussionDetail(
      {required int id});

  /// Create discussion
  Future<Either<Failure, void>> createDiscussion(
      {required DiscussionPostModel discussion});

  /// Edit discussion
  Future<Either<Failure, void>> editDiscussion(
      {required DiscussionDetailModel discussion});

  /// Delete discussion
  Future<Either<Failure, void>> deleteDiscussion({required int id});
}

class DiscussionRepositoryImpl implements DiscussionRepository {
  final DiscussionDataSource discussionDataSource;
  final NetworkInfo networkInfo;

  DiscussionRepositoryImpl({
    required this.discussionDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DiscussionModel>>> getUserDiscussions({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await discussionDataSource.getUserDiscussions(
          query: query,
          status: status,
          type: type,
          offset: offset,
          limit: limit,
          categoryId: categoryId,
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
  Future<Either<Failure, List<DiscussionModel>>> getDiscussions({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await discussionDataSource.getDiscussions(
          query: query,
          status: status,
          type: type,
          offset: offset,
          limit: limit,
          categoryId: categoryId,
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
  Future<Either<Failure, DiscussionDetailModel>> getDiscussionDetail(
      {required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await discussionDataSource.getDiscussionDetail(id: id);

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
  Future<Either<Failure, void>> createDiscussion(
      {required DiscussionPostModel discussion}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await discussionDataSource.createDiscussion(discussion: discussion);

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kNoGeneralQuestionLeft:
            return const Left(
              ServerFailure('Kuota pertanyaan umum telah habis'),
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
  Future<Either<Failure, void>> editDiscussion(
      {required DiscussionDetailModel discussion}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await discussionDataSource.editDiscussion(discussion: discussion);

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
  Future<Either<Failure, void>> deleteDiscussion({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await discussionDataSource.deleteDiscussion(id: id);

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
