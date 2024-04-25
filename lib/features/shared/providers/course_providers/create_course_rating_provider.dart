// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'create_course_rating_provider.g.dart';

@riverpod
class CreateCourseRating extends _$CreateCourseRating {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createCourseRating({
    required int courseId,
    required int rating,
    required String comment,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).createCourseRating(
          courseId: courseId,
          rating: rating,
          comment: comment,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Terima kasih atas ulasan yang diberikan🙏!'),
    );
  }
}
