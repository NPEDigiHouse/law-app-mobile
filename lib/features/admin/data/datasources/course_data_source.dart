// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';
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

abstract class CourseDataSource {
  /// Get courses
  Future<List<CourseModel>> getCourses({
    String query = '',
    int? offset,
    int? limit,
  });

  /// Get course detail
  Future<CourseModel> getCourseDetail({required int id});

  /// Create course
  Future<void> createCourse({required CoursePostModel course});

  /// Edit course
  Future<void> editCourse({required CourseModel course});

  /// Delete course
  Future<void> deleteCourse({required int id});

  /// Get curriculum detail
  Future<CurriculumModel> getCurriculumDetail({required int id});

  /// Create curriculum
  Future<void> createCurriculum({required CurriculumPostModel curriculum});

  /// Edit curriculum
  Future<void> editCurriculum({required CurriculumModel curriculum});

  /// Delete curriculum
  Future<void> deleteCurriculum({required int id});

  /// Get article detail
  Future<ArticleModel> getArticleDetail({required int id});

  /// Create article
  Future<void> createArticle({required ArticlePostModel article});

  /// Edit article
  Future<void> editArticle({required ArticleModel article});

  /// Delete article
  Future<void> deleteArticle({required int id});

  /// Get quiz detail
  Future<QuizModel> getQuizDetail({required int id});

  /// Create quiz
  Future<void> createQuiz({required QuizPostModel quiz});

  /// Edit quiz
  Future<void> editQuiz({required QuizModel quiz});

  /// Delete quiz
  Future<void> deleteQuiz({required int id});

  /// Get all questions by quizId
  Future<List<QuestionModel>> getQuestions({required int quizId});

  /// Get question detail
  Future<QuestionModel> getQuestionDetail({required int id});

  /// Create question
  Future<void> createQuestion({required QuestionPostModel question});

  /// Edit question
  Future<void> editQuestion({required QuestionModel question});

  /// Delete question
  Future<void> deleteQuestion({required int id});

  /// Get all options by questionId
  Future<List<OptionModel>> getOptions({required int questionId});

  /// Create option
  Future<void> createOption({required OptionPostModel option});

  /// Edit option
  Future<void> editOption({required OptionModel option});

  /// Delete option
  Future<void> deleteOption({required int id});

  /// Get user courses
  Future<List<UserCourseModel>> getUserCourses({
    required int userId,
    String? status,
  });

  /// Get user course detail
  Future<UserCourseModel> getUserCourseDetail({required int id});

  /// Create user course
  Future<void> createUserCourse({required int courseId});

  /// Update user course
  Future<void> updateUserCourse({
    required int id,
    required int currentCurriculumSequence,
    required int currentMaterialSequence,
  });

  /// Check quiz score
  Future<QuizResultModel> checkScore({
    required int quizId,
    required List<Map<String, int>> answers,
  });
}

class CourseDataSourceImpl implements CourseDataSource {
  final http.Client client;

  CourseDataSourceImpl({required this.client});

  @override
  Future<List<CourseModel>> getCourses({
    String query = '',
    int? offset,
    int? limit,
  }) async {
    try {
      final queryParams =
          'term=$query&offset=${offset ?? ''}&limit=${limit ?? ''}';

      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/courses?$queryParams'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => CourseModel.fromMap(e)).toList();
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<CourseModel> getCourseDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/courses/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return CourseModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createCourse({required CoursePostModel course}) async {
    try {
      final coverFile = await http.MultipartFile.fromPath(
        'cover',
        course.cover,
        filename: const Uuid().v4() + p.extension(course.cover),
      );

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfigs.baseUrl}/courses'),
      )
        ..fields.addAll({
          'title': course.title,
          'description': course.description,
        })
        ..files.add(coverFile)
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${CredentialSaver.accessToken}';

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> editCourse({required CourseModel course}) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConfigs.baseUrl}/courses/${course.id}'),
      )
        ..fields.addAll({
          'title': '${course.title}',
          'description': '${course.description}',
        })
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${CredentialSaver.accessToken}';

      if (course.coverImg != null) {
        final file = await http.MultipartFile.fromPath(
          'cover',
          course.coverImg!,
          filename: const Uuid().v4() + p.extension(course.coverImg!),
        );

        request.files.add(file);
      }

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> deleteCourse({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/courses/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<CurriculumModel> getCurriculumDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/curriculums/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return CurriculumModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createCurriculum(
      {required CurriculumPostModel curriculum}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/curriculums'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: curriculum.toJson(),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> editCurriculum({required CurriculumModel curriculum}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/curriculums/${curriculum.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({'title': curriculum.title}),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> deleteCurriculum({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/curriculums/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<ArticleModel> getArticleDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/articles/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return ArticleModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createArticle({required ArticlePostModel article}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/articles'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: article.toJson(),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> editArticle({required ArticleModel article}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/articles/${article.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'title': article.title,
          'material': article.material,
          'duration': article.duration,
        }),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> deleteArticle({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/articles/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<QuizModel> getQuizDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/quizes/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return QuizModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createQuiz({required QuizPostModel quiz}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/quizes'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: quiz.toJson(),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> editQuiz({required QuizModel quiz}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/quizes/${quiz.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'title': quiz.title,
          'description': quiz.description,
          'duration': quiz.duration,
        }),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> deleteQuiz({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/quizes/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<List<QuestionModel>> getQuestions({required int quizId}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/quiz-questions?quizId=$quizId'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => QuestionModel.fromMap(e)).toList();
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<QuestionModel> getQuestionDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/quiz-questions/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return QuestionModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createQuestion({required QuestionPostModel question}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/quiz-questions'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: question.toJson(),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> editQuestion({required QuestionModel question}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/quiz-questions/${question.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'title': question.title,
          'correctOptionId': question.correctOptionId,
        }),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> deleteQuestion({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/quiz-questions/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<List<OptionModel>> getOptions({required int questionId}) async {
    try {
      final response = await client.get(
        Uri.parse(
          '${ApiConfigs.baseUrl}/quiz-question-options?questionId=$questionId',
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => OptionModel.fromMap(e)).toList();
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createOption({required OptionPostModel option}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/quiz-question-options'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: option.toJson(),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> editOption({required OptionModel option}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/quiz-question-options/${option.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({'title': option.title}),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> deleteOption({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/quiz-question-options/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<List<UserCourseModel>> getUserCourses({
    required int userId,
    String? status,
  }) async {
    try {
      final queryParams = 'userId=$userId&status=${status ?? ''}';

      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/user-courses?$queryParams'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => UserCourseModel.fromMap(e)).toList();
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<UserCourseModel> getUserCourseDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/user-courses/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return UserCourseModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createUserCourse({required int courseId}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/user-courses'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({'courseId': courseId}),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> updateUserCourse({
    required int id,
    required int currentCurriculumSequence,
    required int currentMaterialSequence,
  }) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/user-courses/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'currentCurriculumSequence': currentCurriculumSequence,
          'currentMaterialSequence': currentMaterialSequence,
        }),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<QuizResultModel> checkScore({
    required int quizId,
    required List<Map<String, int>> answers,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/quizes/check-score/$quizId'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(answers),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return QuizResultModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }
}
