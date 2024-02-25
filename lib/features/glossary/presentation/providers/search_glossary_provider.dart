// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/glossary/data/models/glossary_model.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';

part 'search_glossary_provider.g.dart';

@riverpod
class SearchGlossary extends _$SearchGlossary {
  @override
  AsyncValue<List<GlossaryModel>?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> searchGlossary({String query = ''}) async {
    List<GlossaryModel>? glossaries;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .getGlossaries(query: query, offset: 0, limit: 10);

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
  }
}
