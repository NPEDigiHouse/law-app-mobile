// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/glossary_models/glossary_model.dart';
import 'package:law_app/features/admin/data/models/glossary_models/glossary_post_model.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';

part 'glossary_actions_provider.g.dart';

@riverpod
class GlossaryActions extends _$GlossaryActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createGlossary({required GlossaryPostModel glossary}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(glossaryRepositoryProvider).createGlossary(glossary: glossary);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Glosarium berhasil dibuat!'),
    );
  }

  Future<void> editGlossary({required GlossaryModel glossary}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(glossaryRepositoryProvider).editGlossary(glossary: glossary);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Glosarium berhasil diedit!'),
    );
  }

  Future<void> deleteGlossary({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(glossaryRepositoryProvider).deleteGlossary(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Glosarium berhasil dihapus!'),
    );
  }
}
