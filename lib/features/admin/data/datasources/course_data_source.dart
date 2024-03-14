// Package imports:
// import 'package:http/http.dart' as http;

// Project imports:
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
  Future<List<CourseModel>> getCourses();

  /// Get course detail
  Future<CourseDetailModel> getCourseDetail({required int id});

  /// Create course
  Future<void> createCourse({required CoursePostModel course});

  /// Edit course
  Future<void> editCourse({required CourseDetailModel course});

  /// Delete course
  Future<void> deleteCourse({required int id});

  /// Get curriculums
  Future<List<CurriculumModel>> getCurriculums();

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

// class CourseDataSourceImpl implements CourseDataSource {
//   final http.Client client;

//   CourseDataSourceImpl({required this.client});
// }
