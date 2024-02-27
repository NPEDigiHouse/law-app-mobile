// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/glossary/data/models/glossary_search_history_model.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';

part 'glossary_search_history_provider.g.dart';

@riverpod
class GlossarySearchHistory extends _$GlossarySearchHistory {
  @override
  Future<List<GlossarySearchHistoryModel>?> build() async {
    List<GlossarySearchHistoryModel>? histories;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .getGlossariesSearchHistory();

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => histories = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return histories;
  }

  Future<void> createGlossarySearchHistory({required int id}) async {
    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .createGlossarySearchHistory(id: id);

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

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .deleteGlossarySearchHistory(id: id);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => ref.invalidateSelf(),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }

  Future<void> deleteAllGlossariesSearchHistory() async {
    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .deleteAllGlossariesSearchHistory();

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => ref.invalidateSelf(),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
