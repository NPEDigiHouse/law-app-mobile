// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/course_data_source.dart';
import 'package:law_app/features/admin/data/models/course_models/article_model.dart';
import 'package:law_app/features/admin/data/models/course_models/article_post_model.dart';
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/admin/data/models/course_models/course_post_model.dart';
import 'package:law_app/features/admin/data/models/course_models/curriculum_model.dart';
import 'package:law_app/features/admin/data/models/course_models/curriculum_post_model.dart';
import 'package:law_app/features/admin/data/models/course_models/option_model.dart';
import 'package:law_app/features/admin/data/models/course_models/option_post_model.dart';
import 'package:law_app/features/admin/data/models/course_models/question_model.dart';
import 'package:law_app/features/admin/data/models/course_models/question_post_model.dart';
import 'package:law_app/features/admin/data/models/course_models/quiz_model.dart';
import 'package:law_app/features/admin/data/models/course_models/quiz_post_model.dart';
import 'package:law_app/features/admin/data/models/course_models/quiz_result_model.dart';
import 'package:law_app/features/admin/data/models/course_models/user_course_model.dart';

abstract class CourseRepository {
  /// Get courses
  Future<Either<Failure, List<CourseModel>>> getCourses({
    String query = '',
    int? offset,
    int? limit,
  });

  /// Get course detail
  Future<Either<Failure, CourseModel>> getCourseDetail({required int id});

  /// Create course
  Future<Either<Failure, void>> createCourse({required CoursePostModel course});

  /// Edit course
  Future<Either<Failure, void>> editCourse({required CourseModel course});

  /// Delete course
  Future<Either<Failure, void>> deleteCourse({required int id});

  /// Get curriculum detail
  Future<Either<Failure, CurriculumModel>> getCurriculumDetail({required int id});

  /// Create curriculum
  Future<Either<Failure, void>> createCurriculum({required CurriculumPostModel curriculum});

  /// Edit curriculum
  Future<Either<Failure, void>> editCurriculum({required CurriculumModel curriculum});

  /// Delete curriculum
  Future<Either<Failure, void>> deleteCurriculum({required int id});

  /// Get article detail
  Future<Either<Failure, ArticleModel>> getArticleDetail({required int id});

  /// Create article
  Future<Either<Failure, void>> createArticle({required ArticlePostModel article});

  /// Edit article
  Future<Either<Failure, void>> editArticle({required ArticleModel article});

  /// Delete article
  Future<Either<Failure, void>> deleteArticle({required int id});

  /// Get quiz detail
  Future<Either<Failure, QuizModel>> getQuizDetail({required int id});

  /// Create quiz
  Future<Either<Failure, void>> createQuiz({required QuizPostModel quiz});

  /// Edit quiz
  Future<Either<Failure, void>> editQuiz({required QuizModel quiz});

  /// Delete quiz
  Future<Either<Failure, void>> deleteQuiz({required int id});

  /// Get all questions by quizId
  Future<Either<Failure, List<QuestionModel>>> getQuestions({required int quizId});

  /// Get question detail
  Future<Either<Failure, QuestionModel>> getQuestionDetail({required int id});

  /// Create question
  Future<Either<Failure, void>> createQuestion({required QuestionPostModel question});

  /// Edit question
  Future<Either<Failure, void>> editQuestion({required QuestionModel question});

  /// Delete question
  Future<Either<Failure, void>> deleteQuestion({required int id});

  /// Get all options by questionId
  Future<Either<Failure, List<OptionModel>>> getOptions({required int questionId});

  /// Create option
  Future<Either<Failure, void>> createOption({required OptionPostModel option});

  /// Edit option
  Future<Either<Failure, void>> editOption({required OptionModel option});

  /// Delete option
  Future<Either<Failure, void>> deleteOption({required int id});

  /// Get user courses
  Future<Either<Failure, List<UserCourseModel>>> getUserCourses({
    required int userId,
    String? status,
  });

  /// Get user course detail
  Future<Either<Failure, UserCourseModel>> getUserCourseDetail({required int id});

  /// Create user course
  Future<Either<Failure, void>> createUserCourse({required int courseId});

  /// Update user course
  Future<Either<Failure, void>> updateUserCourse({
    required int id,
    required int currentCurriculumSequence,
    required int currentMaterialSequence,
  });

  /// Check quiz score
  Future<Either<Failure, QuizResultModel>> checkScore({
    required int quizId,
    required List<Map<String, int?>> answers,
  });
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, CourseModel>> getCourseDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getCourseDetail(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createCourse({required CoursePostModel course}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.createCourse(course: course);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editCourse({required CourseModel course}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.editCourse(course: course);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, CurriculumModel>> getCurriculumDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getCurriculumDetail(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createCurriculum({required CurriculumPostModel curriculum}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.createCurriculum(curriculum: curriculum);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editCurriculum({required CurriculumModel curriculum}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.editCurriculum(curriculum: curriculum);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, ArticleModel>> getArticleDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getArticleDetail(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createArticle({required ArticlePostModel article}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.createArticle(article: article);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editArticle({required ArticleModel article}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.editArticle(article: article);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, QuizModel>> getQuizDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getQuizDetail(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createQuiz({required QuizPostModel quiz}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.createQuiz(quiz: quiz);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editQuiz({required QuizModel quiz}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.editQuiz(quiz: quiz);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<QuestionModel>>> getQuestions({required int quizId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getQuestions(quizId: quizId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, QuestionModel>> getQuestionDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getQuestionDetail(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createQuestion({required QuestionPostModel question}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.createQuestion(question: question);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editQuestion({required QuestionModel question}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.editQuestion(question: question);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuestion({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.deleteQuestion(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<OptionModel>>> getOptions({required int questionId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getOptions(questionId: questionId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createOption({required OptionPostModel option}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.createOption(option: option);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editOption({required OptionModel option}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.editOption(option: option);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOption({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.deleteOption(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<UserCourseModel>>> getUserCourses({
    required int userId,
    String? status,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getUserCourses(
          userId: userId,
          status: status,
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
  Future<Either<Failure, UserCourseModel>> getUserCourseDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.getUserCourseDetail(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createUserCourse({required int courseId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.createUserCourse(courseId: courseId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserCourse({
    required int id,
    required int currentCurriculumSequence,
    required int currentMaterialSequence,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.updateUserCourse(
          id: id,
          currentCurriculumSequence: currentCurriculumSequence,
          currentMaterialSequence: currentMaterialSequence,
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
  Future<Either<Failure, QuizResultModel>> checkScore({
    required int quizId,
    required List<Map<String, int?>> answers,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await courseDataSource.checkScore(
          quizId: quizId,
          answers: answers,
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
