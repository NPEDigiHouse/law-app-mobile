// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/quiz_detail_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'quiz_detail_provider.g.dart';

@riverpod
class QuizDetail extends _$QuizDetail {
  @override
  Future<QuizDetailModel?> build({required int id}) async {
    QuizDetailModel? quiz;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).getQuizDetail(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        quiz = r;
        state = AsyncValue.data(r);
      },
    );

    return quiz;
  }
}
