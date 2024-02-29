// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/glossary_models/glossary_model.dart';
import 'package:law_app/features/admin/data/models/glossary_models/glossary_post_model.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';

part 'glossaries_provider.g.dart';

@riverpod
class Glossaries extends _$Glossaries {
  @override
  Future<List<GlossaryModel>?> build() async {
    List<GlossaryModel>? glossaries;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(glossaryRepositoryProvider).getGlossaries();

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) {
          glossaries = r;
          state = AsyncValue.data(r);
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return glossaries;
  }

  Future<void> searchGlossaries({String query = ''}) async {
    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .getGlossaries(query: query);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => state = AsyncValue.data(r),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }

  Future<void> createGlossary({required GlossaryPostModel glossary}) async {
    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .createGlossary(glossary: glossary);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => ref.invalidateSelf(),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }

  Future<void> deleteGlossary({required int id}) async {
    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(glossaryRepositoryProvider).deleteGlossary(id: id);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => ref.invalidateSelf(),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
