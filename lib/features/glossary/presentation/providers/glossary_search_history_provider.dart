// Package imports:
import 'package:law_app/features/glossary/data/models/glossary_search_history_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/glossary/presentation/providers/repositories_provider/glossary_repository_provider.dart';

part 'glossary_search_history_provider.g.dart';

@riverpod
class GlossarySearchHistory extends _$GlossarySearchHistory {
  @override
  Future<List<GlossarySearchHistoryModel>?> build() async {
    List<GlossarySearchHistoryModel>? histories;
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .getGlossariesSearchHistory();

      result.fold(
        (l) => failure = l,
        (r) => histories = r,
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    } finally {
      if (histories != null) {
        state = AsyncValue.data(histories);
      } else {
        state = AsyncValue.error(failure!.message, StackTrace.current);
      }
    }

    return histories;
  }

  Future<void> createGlossarySearchHistory({required int id}) async {
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .createGlossarySearchHistory(id: id);

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

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .deleteGlossarySearchHistory(id: id);

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

  Future<void> deleteAllGlossariesSearchHistory() async {
    Failure? failure;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(glossaryRepositoryProvider)
          .deleteAllGlossariesSearchHistory();

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
