// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'get_discussions_provider.g.dart';

@riverpod
class GetDiscussions extends _$GetDiscussions {
  @override
  Future<({List<DiscussionModel>? discussions, bool? hasMore})> build({
    String query = '',
    String status = '',
    String type = '',
    int? categoryId,
  }) async {
    List<DiscussionModel>? discussions;
    bool? hasMore;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(discussionRepositoryProvider).getDiscussions(
                query: query,
                status: status,
                type: type,
                categoryId: categoryId,
                offset: 0,
                limit: 20,
              );

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) {
          discussions = r;
          hasMore = r.length == 20;

          state = AsyncValue.data((discussions: discussions, hasMore: hasMore));
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return (discussions: discussions, hasMore: hasMore);
  }

  Future<void> fetchMoreDiscussions({
    String query = '',
    String status = '',
    String type = '',
    int? categoryId,
    required int offset,
  }) async {
    try {
      final result =
          await ref.watch(discussionRepositoryProvider).getDiscussions(
                query: query,
                status: status,
                type: type,
                categoryId: categoryId,
                offset: offset,
                limit: 20,
              );

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) {
          final previousState = state.valueOrNull;

          if (previousState != null) {
            state = AsyncValue.data((
              discussions: [...previousState.discussions!, ...r],
              hasMore: r.length == 20,
            ));
          }
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
