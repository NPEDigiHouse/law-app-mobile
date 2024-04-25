// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'discussion_detail_provider.g.dart';

@riverpod
class DiscussionDetail extends _$DiscussionDetail {
  @override
  Future<DiscussionModel?> build({required int id}) async {
    DiscussionModel? discussionDetail;

    state = const AsyncValue.loading();

    final result = await ref.watch(discussionRepositoryProvider).getDiscussionDetail(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        discussionDetail = r;
        state = AsyncValue.data(r);
      },
    );

    return discussionDetail;
  }
}
