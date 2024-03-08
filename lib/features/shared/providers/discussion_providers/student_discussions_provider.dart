// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_credential_model.dart';
import 'package:law_app/features/auth/presentation/providers/user_credential_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'student_discussions_provider.g.dart';

@riverpod
class StudentDiscussions extends _$StudentDiscussions {
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

    state = const AsyncValue.loading();

    final result1 = await ref
        .watch(discussionRepositoryProvider)
        .getUserDiscussions(offset: 0, limit: kPageLimit);

    final result2 = await ref
        .watch(discussionRepositoryProvider)
        .getDiscussions(offset: 0, limit: kPageLimit, type: 'general');

    ref.listen(userCredentialProvider, (_, state) {
      state.when(
        loading: () => this.state = const AsyncValue.loading(),
        error: (e, _) {
          this.state =
              AsyncValue.error((e as Failure).message, StackTrace.current);
        },
        data: (data) {
          userCredential = data;

          result1.fold(
            (l) {},
            (r) => userDiscussions = r,
          );

          result2.fold(
            (l) {},
            (r) => publicDiscussions = r,
          );

          this.state = AsyncValue.data((
            userCredential: userCredential,
            userDiscussions: userDiscussions,
            publicDiscussions: publicDiscussions,
          ));
        },
      );
    });

    return (
      userCredential: userCredential,
      userDiscussions: userDiscussions,
      publicDiscussions: publicDiscussions,
    );
  }
}
