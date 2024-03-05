// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/models/glossary_models/glossary_model.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';

part 'search_glossary_provider.g.dart';

@riverpod
class SearchGlossary extends _$SearchGlossary {
  @override
  AsyncValue<({List<GlossaryModel> glossaries, bool hasMore})?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> searchGlossary({String query = ''}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(glossaryRepositoryProvider)
        .getGlossaries(query: query, offset: 0, limit: kPageLimit);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data((
        glossaries: r,
        hasMore: r.length == kPageLimit,
      )),
    );
  }

  Future<void> fetchMoreGlossary({
    required int offset,
    String query = '',
  }) async {
    final result = await ref
        .watch(glossaryRepositoryProvider)
        .getGlossaries(query: query, offset: offset, limit: kPageLimit);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        final previousState = state.valueOrNull;

        if (previousState != null) {
          state = AsyncValue.data((
            glossaries: [...previousState.glossaries, ...r],
            hasMore: r.length == kPageLimit,
          ));
        }
      },
    );
  }
}
