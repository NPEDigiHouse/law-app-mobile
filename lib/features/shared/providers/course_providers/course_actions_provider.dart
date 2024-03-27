// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/admin/data/models/course_models/course_post_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'course_actions_provider.g.dart';

@riverpod
class CourseActions extends _$CourseActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createCourse({required CoursePostModel course}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).createCourse(course: course);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Course berhasil dibuat!'),
    );
  }

  Future<void> editCourse({required CourseModel course}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).editCourse(course: course);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil mengedit course!'),
    );
  }

  Future<void> deleteCourse({required int id}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).deleteCourse(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Course berhasil dihapus!'),
    );
  }
}
