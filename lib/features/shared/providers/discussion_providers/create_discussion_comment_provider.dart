// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'create_discussion_comment_provider.g.dart';

@riverpod
class CreateDiscussionComment extends _$CreateDiscussionComment {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createDiscussionComment({
    required int userId,
    required int discussionId,
    required String text,
  }) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(discussionRepositoryProvider).createDiscussionComment(
              userId: userId,
              discussionId: discussionId,
              text: text,
            );

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
