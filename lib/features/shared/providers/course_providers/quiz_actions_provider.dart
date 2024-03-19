// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/quiz_detail_model.dart';
import 'package:law_app/features/admin/data/models/course_models/quiz_post_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'quiz_actions_provider.g.dart';

@riverpod
class QuizActions extends _$QuizActions {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createQuiz({required QuizPostModel quiz}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).createQuiz(quiz: quiz);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }

  Future<void> editQuiz({required QuizDetailModel quiz}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).editQuiz(quiz: quiz);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }

  Future<void> deleteQuiz({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).deleteQuiz(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
