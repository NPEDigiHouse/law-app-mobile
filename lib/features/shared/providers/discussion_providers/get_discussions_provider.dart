// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_credential_model.dart';
import 'package:law_app/features/auth/presentation/providers/get_user_credential_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'get_discussions_provider.g.dart';

@riverpod
class GetDiscussions extends _$GetDiscussions {
  @override
  Future<
      ({
        UserCredentialModel? userCredential,
        List<DiscussionModel>? userDiscussions,
        List<DiscussionModel>? publicDiscussions,
      })> build() async {
    UserCredentialModel? userCredential;
    List<DiscussionModel>? userDiscussions;
    List<DiscussionModel>? publicDiscussions;

    try {
      state = const AsyncValue.loading();

      final result1 = await ref
          .watch(discussionRepositoryProvider)
          .getUserDiscussions(status: 'open', type: 'general');

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

              ref.listen(getUserCredentialProvider, (_, state) {
                state.whenOrNull(
                  error: (error, _) {
                    this.state = AsyncValue.error(
                      (error as Failure).message,
                      StackTrace.current,
                    );
                  },
                  data: (data) {
                    userCredential = data;

                    this.state = AsyncValue.data((
                      userCredential: data,
                      userDiscussions: userDiscussions,
                      publicDiscussions: publicDiscussions,
                    ));
                  },
                );
              });
            },
          );
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return (
      userCredential: userCredential,
      userDiscussions: userDiscussions,
      publicDiscussions: publicDiscussions,
    );
  }
}
