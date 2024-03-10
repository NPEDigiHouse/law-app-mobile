// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_credential_model.dart';
import 'package:law_app/features/auth/presentation/providers/user_credential_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'teacher_discussions_provider.g.dart';

@riverpod
class TeacherDiscussions extends _$TeacherDiscussions {
  @override
  Future<
      ({
        UserCredentialModel? userCredential,
        List<DiscussionModel>? userDiscussions,
        List<DiscussionModel>? publicDiscussions,
        List<DiscussionModel>? specificDiscussions,
      })> build() async {
    UserCredentialModel? userCredential;
    List<DiscussionModel>? userDiscussions;
    List<DiscussionModel>? publicDiscussions;
    List<DiscussionModel>? specificDiscussions;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(discussionRepositoryProvider).getUserDiscussions();

    final result2 = await ref
        .watch(discussionRepositoryProvider)
        .getDiscussions(limit: kPageLimit, type: 'general');

    final result3 = await ref
        .watch(discussionRepositoryProvider)
        .getDiscussions(type: 'specific', status: 'open');

    ref.listen(userCredentialProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          this.state = AsyncValue.error(
            (error as Failure).message,
            StackTrace.current,
          );
        },
        data: (data) {
          userCredential = data;

          result.fold(
            (l) {},
            (r) => userDiscussions = r,
          );

          result2.fold(
            (l) {},
            (r) => publicDiscussions = r,
          );

          result3.fold(
            (l) {},
            (r) {
              specificDiscussions = r.where((e) {
                return CredentialSaver.user!.expertises!.contains(e.category);
              }).toList();
            },
          );

          this.state = AsyncValue.data((
            userCredential: userCredential,
            userDiscussions: userDiscussions,
            publicDiscussions: publicDiscussions,
            specificDiscussions: specificDiscussions,
          ));
        },
      );
    });

    return (
      userCredential: userCredential,
      userDiscussions: userDiscussions,
      publicDiscussions: publicDiscussions,
      specificDiscussions: specificDiscussions,
    );
  }
}
