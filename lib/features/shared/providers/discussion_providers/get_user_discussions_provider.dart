// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'get_user_discussions_provider.g.dart';

@riverpod
class GetUserDiscussions extends _$GetUserDiscussions {
  @override
  Future<List<DiscussionModel>?> build({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  }) async {
    List<DiscussionModel>? discussions;

    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(discussionRepositoryProvider).getUserDiscussions(
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
          state = AsyncValue.data(discussions);
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return discussions;
  }
}
