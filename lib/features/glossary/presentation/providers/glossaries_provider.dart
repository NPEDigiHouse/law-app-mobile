import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/glossary/data/models/glossary_model.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';
import 'package:law_app/features/shared/models/glossary_post_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'glossaries_provider.g.dart';

@riverpod
class Glossaries extends _$Glossaries {
  @override
  Future<List<GlossaryModel>?> build() async {
    List<GlossaryModel>? glossaries;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref.watch(glossaryRepositoryProvider).getGlossaries(
            offset: 0,
            limit: 10,
          );

      result.fold(
        (l) => failure = l,
        (r) => glossaries = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (glossaries != null) {
        state = AsyncValue.data(glossaries);
      } else {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }

    return glossaries;
  }

  Future<void> createGlossary({required GlossaryPostModel glossary}) async {
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .createGlossary(glossary: glossary);

      result.fold(
        (l) => failure = l,
        (r) => {},
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (failure != null) {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      } else {
        ref.invalidateSelf();
      }
    }
  }

  Future<void> deleteGlossary({required int id}) async {
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(glossaryRepositoryProvider).deleteGlossary(id: id);

      result.fold(
        (l) => failure = l,
        (r) => {},
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (failure != null) {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      } else {
        ref.invalidateSelf();
      }
    }
  }
}
