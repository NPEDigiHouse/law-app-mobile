// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/question_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'question_provider.g.dart';

@riverpod
class Question extends _$Question {
  @override
  Future<List<QuestionModel>?> build({required int quizId}) async {
    List<QuestionModel>? questions;

    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).getQuestions(quizId: quizId);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        questions = r;
        state = AsyncValue.data(r);
      },
    );

    return questions;
  }
}
