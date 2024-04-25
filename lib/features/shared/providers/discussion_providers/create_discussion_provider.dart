// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/discussion_models/discussion_post_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'create_discussion_provider.g.dart';

@riverpod
class CreateDiscussion extends _$CreateDiscussion {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createDiscussion({required DiscussionPostModel discussion}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(discussionRepositoryProvider).createDiscussion(discussion: discussion);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
