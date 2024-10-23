// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/admin/data/models/course_models/user_course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'course_detail_provider.g.dart';

@riverpod
class CourseDetail extends _$CourseDetail {
  @override
  Future<({CourseModel? course, UserCourseModel? userCourse})> build({required int id}) async {
    CourseModel? course;
    UserCourseModel? userCourse;

    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).getCourseDetail(id: id);

    final result2 = await ref.watch(courseRepositoryProvider).getUserCourses(userId: CredentialSaver.user!.id!);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        course = r;

        result2.fold(
          (l) => state = AsyncValue.error(l.message, StackTrace.current),
          (r) {
            final courses = r.where((e) => e.course!.id == course!.id).toList();

            userCourse = courses.isEmpty ? null : courses.first;

            state = AsyncValue.data((course: course, userCourse: userCourse));
          },
        );
      },
    );

    return (course: course, userCourse: userCourse);
  }
}
