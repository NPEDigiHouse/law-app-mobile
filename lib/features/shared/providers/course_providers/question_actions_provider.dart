// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/question_model.dart';
import 'package:law_app/features/admin/data/models/course_models/question_post_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'question_actions_provider.g.dart';

@riverpod
class QuestionActions extends _$QuestionActions {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createQuestion({required QuestionPostModel question}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(courseRepositoryProvider)
        .createQuestion(question: question);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }

  Future<void> editQuestion({required QuestionModel question}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(courseRepositoryProvider)
        .editQuestion(question: question);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }

  Future<void> deleteQuestion({required int id}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).deleteQuestion(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
