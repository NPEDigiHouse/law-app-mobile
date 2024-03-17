// Package imports:
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/course_data_source.dart';
import 'package:law_app/features/admin/data/models/course_models/article_detail_model.dart';
import 'package:law_app/features/admin/data/models/course_models/article_post_model.dart';
import 'package:law_app/features/admin/data/models/course_models/course_detail_model.dart';
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/admin/data/models/course_models/course_post_model.dart';
import 'package:law_app/features/admin/data/models/course_models/curriculum_detail_model.dart';
import 'package:law_app/features/admin/data/models/course_models/curriculum_model.dart';
import 'package:law_app/features/admin/data/models/course_models/curriculum_post_model.dart';
import 'package:law_app/features/admin/data/models/course_models/quiz_detail_model.dart';
import 'package:law_app/features/admin/data/models/course_models/quiz_post_model.dart';

abstract class CourseRepository {
  /// Get courses
  Future<Either<Failure, List<CourseModel>>> getCourses({
    String query = '',
    int? offset,
    int? limit,
  });

  /// Get course detail
  Future<Either<Failure, CourseDetailModel>> getCourseDetail({required int id});

  /// Create course
  Future<Either<Failure, void>> createCourse({required CoursePostModel course});

  /// Edit course
  Future<Either<Failure, void>> editCourse({required CourseDetailModel course});

  /// Delete course
  Future<Either<Failure, void>> deleteCourse({required int id});

  /// Get curriculum detail
  Future<Either<Failure, CurriculumDetailModel>> getCurriculumDetail(
      {required int id});

  /// Create curriculum
  Future<Either<Failure, void>> createCurriculum(
      {required CurriculumPostModel curriculum});

  /// Edit curriculum
  Future<Either<Failure, void>> editCurriculum(
      {required CurriculumModel curriculum});

  /// Delete curriculum
  Future<Either<Failure, void>> deleteCurriculum({required int id});

  /// Get article detail
  Future<Either<Failure, ArticleDetailModel>> getArticleDetail(
      {required int id});

  /// Create article
  Future<Either<Failure, void>> createArticle(
      {required ArticlePostModel article});

  /// Edit article
  Future<Either<Failure, void>> editArticle(
      {required ArticleDetailModel article});

  /// Delete article
  Future<Either<Failure, void>> deleteArticle({required int id});

  /// Get quiz detail
  Future<Either<Failure, QuizDetailModel>> getQuizDetail({required int id});

  /// Create quiz
  Future<Either<Failure, void>> createQuiz({required QuizPostModel quiz});

  /// Edit quiz
  Future<Either<Failure, void>> editQuiz({required QuizDetailModel quiz});

  /// Delete quiz
  Future<Either<Failure, void>> deleteQuiz({required int id});
}

class CourseRepositoryImpl implements CourseRepository {
  final CourseDataSource courseDataSource;
  final NetworkInfo networkInfo;

  CourseRepositoryImpl({
    required this.courseDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CourseModel>>> getCourses({
    String query = '',
    int? offset,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getCourses(
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
  Future<Either<Failure, CourseDetailModel>> getCourseDetail(
      {required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getCourseDetail(id: id);

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
  Future<Either<Failure, void>> createCourse(
      {required CoursePostModel course}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.createCourse(course: course);

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
  Future<Either<Failure, void>> editCourse(
      {required CourseDetailModel course}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.editCourse(course: course);

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
  Future<Either<Failure, void>> deleteCourse({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.deleteCourse(id: id);

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
  Future<Either<Failure, CurriculumDetailModel>> getCurriculumDetail(
      {required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getCurriculumDetail(id: id);

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
  Future<Either<Failure, void>> createCurriculum(
      {required CurriculumPostModel curriculum}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await courseDataSource.createCurriculum(curriculum: curriculum);

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
  Future<Either<Failure, void>> editCurriculum(
      {required CurriculumModel curriculum}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await courseDataSource.editCurriculum(curriculum: curriculum);

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
  Future<Either<Failure, void>> deleteCurriculum({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.deleteCurriculum(id: id);

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
  Future<Either<Failure, ArticleDetailModel>> getArticleDetail(
      {required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getArticleDetail(id: id);

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
  Future<Either<Failure, void>> createArticle(
      {required ArticlePostModel article}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.createArticle(article: article);

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
  Future<Either<Failure, void>> editArticle(
      {required ArticleDetailModel article}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.editArticle(article: article);

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
  Future<Either<Failure, void>> deleteArticle({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.deleteArticle(id: id);

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
  Future<Either<Failure, QuizDetailModel>> getQuizDetail(
      {required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getQuizDetail(id: id);

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
  Future<Either<Failure, void>> createQuiz(
      {required QuizPostModel quiz}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.createQuiz(quiz: quiz);

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
  Future<Either<Failure, void>> editQuiz(
      {required QuizDetailModel quiz}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.editQuiz(quiz: quiz);

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
  Future<Either<Failure, void>> deleteQuiz({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.deleteQuiz(id: id);

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
