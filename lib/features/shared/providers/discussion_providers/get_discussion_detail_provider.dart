// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_detail_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'get_discussion_detail_provider.g.dart';

@riverpod
class GetDiscussionDetail extends _$GetDiscussionDetail {
  @override
  Future<DiscussionDetailModel?> build({required int id}) async {
    DiscussionDetailModel? discussionDetail;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(discussionRepositoryProvider)
          .getDiscussionDetail(id: id);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) {
          discussionDetail = r;
          state = AsyncValue.data(r);
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return discussionDetail;
  }
}
