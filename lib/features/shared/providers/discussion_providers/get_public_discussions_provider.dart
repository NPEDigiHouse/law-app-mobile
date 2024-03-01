// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'get_public_discussions_provider.g.dart';

@riverpod
class GetPublicDiscussions extends _$GetPublicDiscussions {
  @override
  Future<({List<DiscussionModel>? discussions, bool? hasMore})> build({
    String query = '',
    int? categoryId,
  }) async {
    List<DiscussionModel>? discussions;
    bool? hasMore;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(discussionRepositoryProvider).getDiscussions(
                query: query,
                categoryId: categoryId,
                type: 'general',
                offset: 0,
                limit: 10,
              );

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) {
          discussions = r;
          hasMore = r.length == 10;

          state = AsyncValue.data((discussions: discussions, hasMore: hasMore));
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return (discussions: discussions, hasMore: hasMore);
  }

  Future<void> fetchMorePublicDiscussions({
    required int offset,
    String query = '',
    int? categoryId,
  }) async {
    try {
      final result =
          await ref.watch(discussionRepositoryProvider).getDiscussions(
                query: query,
                categoryId: categoryId,
                type: 'general',
                offset: offset,
                limit: 10,
              );

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) {
          final previousState = state.valueOrNull;

          if (previousState != null) {
            state = AsyncValue.data((
              discussions: [...previousState.discussions!, ...r],
              hasMore: r.length == 10,
            ));
          }
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
