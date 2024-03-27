// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/option_model.dart';
import 'package:law_app/features/admin/data/models/course_models/option_post_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'option_actions_provider.g.dart';

@riverpod
class OptionActions extends _$OptionActions {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createOption({required OptionPostModel option}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).createOption(option: option);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }

  Future<void> editOption({required OptionModel option}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).editOption(option: option);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }

  Future<void> deleteOption({required int id}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).deleteOption(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data(true),
    );
  }
}
