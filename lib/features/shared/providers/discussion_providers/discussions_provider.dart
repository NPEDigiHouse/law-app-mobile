// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'discussions_provider.g.dart';

@riverpod
class Discussions extends _$Discussions {
  @override
  Future<({List<DiscussionModel>? discussions, bool? hasMore})> build({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  }) async {
    List<DiscussionModel>? discussions;
    bool? hasMore;

    state = const AsyncValue.loading();

    final result = await ref.watch(discussionRepositoryProvider).getDiscussions(
          query: query,
          status: status,
          type: type,
          offset: offset,
          limit: limit,
          categoryId: categoryId,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        discussions = r;
        hasMore = r.length == limit;

        state = AsyncValue.data((discussions: discussions, hasMore: hasMore));
      },
    );

    return (discussions: discussions, hasMore: hasMore);
  }

  Future<void> fetchMoreDiscussions({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  }) async {
    final result = await ref.watch(discussionRepositoryProvider).getDiscussions(
          query: query,
          status: status,
          type: type,
          offset: offset,
          limit: limit,
          categoryId: categoryId,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        final previousState = state.valueOrNull;

        if (previousState != null) {
          state = AsyncValue.data((
            discussions: [...previousState.discussions!, ...r],
            hasMore: r.length == limit,
          ));
        }
      },
    );
  }
}
