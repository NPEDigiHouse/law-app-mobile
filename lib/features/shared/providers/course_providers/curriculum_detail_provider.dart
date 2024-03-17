// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/curriculum_detail_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'curriculum_detail_provider.g.dart';

@riverpod
class CurriculumDetail extends _$CurriculumDetail {
  @override
  Future<CurriculumDetailModel?> build({required int id}) async {
    CurriculumDetailModel? curriculum;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).getCurriculumDetail(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        curriculum = r;
        state = AsyncValue.data(r);
      },
    );

    return curriculum;
  }
}
