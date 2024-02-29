// Package imports:
import 'package:law_app/features/admin/data/models/discussion_models/discussion_post_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'discussions_provider.g.dart';

@riverpod
class Discussions extends _$Discussions {
  @override
  Future<
      ({
        List<DiscussionModel>? userDiscussions,
        List<DiscussionModel>? publicDiscussions,
      })> build() async {
    List<DiscussionModel>? userDiscussions;
    List<DiscussionModel>? publicDiscussions;

    try {
      state = const AsyncValue.loading();

      final result1 =
          await ref.watch(discussionRepositoryProvider).getUserDiscussions();

      final result2 = await ref
          .watch(discussionRepositoryProvider)
          .getDiscussions(status: 'open', type: 'general');

      result1.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) {
          userDiscussions = r;

          result2.fold(
            (l) => state = AsyncValue.error(l.message, StackTrace.current),
            (r) {
              publicDiscussions = r;

              state = AsyncValue.data((
                userDiscussions: userDiscussions,
                publicDiscussions: publicDiscussions,
              ));
            },
          );
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return (
      userDiscussions: userDiscussions,
      publicDiscussions: publicDiscussions,
    );
  }

  Future<void> createDiscussion(
      {required DiscussionPostModel discussion}) async {
    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(discussionRepositoryProvider)
          .createDiscussion(discussion: discussion);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => ref.invalidateSelf(),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
