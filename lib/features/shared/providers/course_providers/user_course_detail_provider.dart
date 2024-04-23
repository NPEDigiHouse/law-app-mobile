// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/user_course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'user_course_detail_provider.g.dart';

@riverpod
class UserCourseDetail extends _$UserCourseDetail {
  @override
  Future<UserCourseModel?> build({required int id}) async {
    UserCourseModel? userCourse;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).getUserCourseDetail(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        userCourse = r;
        state = AsyncValue.data(r);
      },
    );

    return userCourse;
  }
}
