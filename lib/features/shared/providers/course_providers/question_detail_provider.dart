// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/option_model.dart';
import 'package:law_app/features/admin/data/models/course_models/question_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'question_detail_provider.g.dart';

@riverpod
class QuestionDetail extends _$QuestionDetail {
  @override
  Future<({QuestionModel? question, List<OptionModel>? options})> build({required int id}) async {
    QuestionModel? question;
    List<OptionModel>? options;

    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).getQuestionDetail(id: id);

    final result2 = await ref.watch(courseRepositoryProvider).getOptions(questionId: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        question = r;

        result2.fold(
          (l) => state = AsyncValue.error(l.message, StackTrace.current),
          (r) {
            options = r;
            state = AsyncValue.data((question: question, options: options));
          },
        );
      },
    );

    return (question: question, options: options);
  }
}
