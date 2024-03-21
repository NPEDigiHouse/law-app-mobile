// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/curriculum_model.dart';
import 'package:law_app/features/admin/data/models/course_models/curriculum_post_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'curriculum_actions_provider.g.dart';

@riverpod
class CurriculumActions extends _$CurriculumActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createCurriculum(
      {required CurriculumPostModel curriculum}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(courseRepositoryProvider)
        .createCurriculum(curriculum: curriculum);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil menambahkan kurikulum!'),
    );
  }

  Future<void> editCurriculum({required CurriculumModel curriculum}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(courseRepositoryProvider)
        .editCurriculum(curriculum: curriculum);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Nama kurikulum berhasil diubah!'),
    );
  }

  Future<void> deleteCurriculum({required int id}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).deleteCurriculum(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Kurikulum telah dihapus!'),
    );
  }
}
