// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'edit_discussion_provider.g.dart';

@riverpod
class EditDiscussion extends _$EditDiscussion {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> editDiscussion({
    required int discussionId,
    int? handlerId,
    String? status,
    String? type,
  }) async {
    try {
      state = const AsyncValue.loading();

      final result =
          await ref.watch(discussionRepositoryProvider).editDiscussion(
                discussionId: discussionId,
                handlerId: handlerId,
                status: status,
                type: type,
              );

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => state = const AsyncValue.data(true),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
