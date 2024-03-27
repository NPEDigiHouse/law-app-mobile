// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'course_detail_provider.g.dart';

@riverpod
class CourseDetail extends _$CourseDetail {
  @override
  Future<CourseModel?> build({required int id}) async {
    CourseModel? course;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).getCourseDetail(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        course = r;
        state = AsyncValue.data(r);
      },
    );

    return course;
  }
}
