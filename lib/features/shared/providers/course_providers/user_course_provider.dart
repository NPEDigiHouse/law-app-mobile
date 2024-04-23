// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/user_course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'user_course_provider.g.dart';

@riverpod
class UserCourse extends _$UserCourse {
  @override
  Future<List<UserCourseModel>?> build({
    required int userId,
    String? status,
  }) async {
    List<UserCourseModel>? userCourses;

    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).getUserCourses(
          userId: userId,
          status: status,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        userCourses = r;
        state = AsyncValue.data(r);
      },
    );

    return userCourses;
  }
}
