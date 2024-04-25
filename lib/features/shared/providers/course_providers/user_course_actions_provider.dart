// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'user_course_actions_provider.g.dart';

@riverpod
class UserCourseActions extends _$UserCourseActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createUserCourse({required int courseId}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).createUserCourse(courseId: courseId);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(
        'Anda telah terdaftar pada course ini. Selamat belajar!',
      ),
    );
  }

  Future<void> updateUserCourse({
    required int id,
    required int currentCurriculumSequence,
    required int currentMaterialSequence,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).updateUserCourse(
          id: id,
          currentCurriculumSequence: currentCurriculumSequence,
          currentMaterialSequence: currentMaterialSequence,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(''),
    );
  }
}
