// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/glossary_models/glossary_model.dart';
import 'package:law_app/features/admin/data/models/glossary_models/glossary_search_history_model.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';

part 'glossary_search_history_provider.g.dart';

@riverpod
class GlossarySearchHistory extends _$GlossarySearchHistory {
  @override
  Future<List<GlossarySearchHistoryModel>?> build() async {
    List<GlossarySearchHistoryModel>? histories;

    state = const AsyncValue.loading();

    final result = await ref
        .watch(glossaryRepositoryProvider)
        .getGlossariesSearchHistory();

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        final historiesSort = r
          ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!) * -1);

        histories = historiesSort;
        state = AsyncValue.data(historiesSort);
      },
    );

    return histories;
  }

  Future<void> createGlossarySearchHistory({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(glossaryRepositoryProvider)
        .createGlossarySearchHistory(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<void> deleteGlossarySearchHistory({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(glossaryRepositoryProvider)
        .deleteGlossarySearchHistory(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<void> deleteAllGlossariesSearchHistory() async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(glossaryRepositoryProvider)
        .deleteAllGlossariesSearchHistory();

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  bool isGlossaryAlreadyExist(GlossaryModel glossaryModel) {
    final previousState = state.valueOrNull;

    if (previousState != null) {
      final test = previousState.where((e) => e.glosarium == glossaryModel);

      return test.isNotEmpty;
    }

    return false;
  }
}
