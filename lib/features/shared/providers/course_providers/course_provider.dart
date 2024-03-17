// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'course_provider.g.dart';

@riverpod
class Course extends _$Course {
  @override
  Future<({List<CourseModel>? courses, bool? hasMore})> build(
      {String query = ''}) async {
    List<CourseModel>? courses;
    bool? hasMore;

    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).getCourses(
          query: query,
          limit: kPageLimit,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        courses = r;
        hasMore = r.length == kPageLimit;
        state = AsyncValue.data((courses: courses, hasMore: hasMore));
      },
    );

    return (courses: courses, hasMore: hasMore);
  }

  Future<void> fetchMoreCourses({
    String query = '',
    required int offset,
  }) async {
    final result = await ref.watch(courseRepositoryProvider).getCourses(
          query: query,
          offset: offset,
          limit: kPageLimit,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        final previousState = state.valueOrNull;

        if (previousState != null) {
          state = AsyncValue.data((
            courses: [...previousState.courses!, ...r],
            hasMore: r.length == kPageLimit,
          ));
        }
      },
    );
  }
}
