// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/quiz_result_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'check_score_provider.g.dart';

@riverpod
class CheckScore extends _$CheckScore {
  @override
  AsyncValue<QuizResultModel?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> checkScore({
    required int quizId,
    required List<Map<String, int>> answers,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).checkScore(
          quizId: quizId,
          answers: answers,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }
}
