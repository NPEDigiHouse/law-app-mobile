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

abstract class CourseDataSource {
  /// Get courses
  Future<List<CourseModel>> getCourses({
    String query = '',
    int? offset,
    int? limit,
  });

  /// Get course detail
  Future<CourseDetailModel> getCourseDetail({required int id});

  /// Create course
  Future<void> createCourse({required CoursePostModel course});

  /// Edit course
  Future<void> editCourse({required CourseDetailModel course});

  /// Delete course
  Future<void> deleteCourse({required int id});

  /// Get curriculum detail
  Future<CurriculumDetailModel> getCurriculumDetail({required int id});

  /// Create curriculum
  Future<void> createCurriculum({required CurriculumPostModel curriculum});

  /// Edit curriculum
  Future<void> editCurriculum({required CurriculumModel curriculum});

  /// Delete curriculum
  Future<void> deleteCurriculum({required int id});

  /// Get article detail
  Future<ArticleDetailModel> getArticleDetail({required int id});

  /// Create article
  Future<void> createArticle({required ArticlePostModel article});

  /// Edit article
  Future<void> editArticle({required ArticleDetailModel article});

  /// Delete article
  Future<void> deleteArticle({required int id});

  /// Get quiz detail
  Future<QuizDetailModel> getQuizDetail({required int id});

  /// Create quiz
  Future<void> createQuiz({required QuizPostModel quiz});

  /// Edit quiz
  Future<void> editQuiz({required QuizDetailModel quiz});

  /// Delete quiz
  Future<void> deleteQuiz({required int id});
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
  Future<CourseDetailModel> getCourseDetail({required int id}) async {
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
        return CourseDetailModel.fromMap(result.data);
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

      final streamedResponse = await request.send();
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
  Future<void> editCourse({required CourseDetailModel course}) async {
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

      final streamedResponse = await request.send();
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
  Future<CurriculumDetailModel> getCurriculumDetail({required int id}) async {
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
        return CurriculumDetailModel.fromMap(result.data);
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
  Future<ArticleDetailModel> getArticleDetail({required int id}) async {
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
        return ArticleDetailModel.fromMap(result.data);
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
  Future<void> editArticle({required ArticleDetailModel article}) async {
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
  Future<QuizDetailModel> getQuizDetail({required int id}) async {
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
        return QuizDetailModel.fromMap(result.data);
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
  Future<void> editQuiz({required QuizDetailModel quiz}) async {
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
}
