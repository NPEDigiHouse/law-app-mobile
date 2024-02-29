// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_category_model.dart';
import 'package:law_app/features/admin/presentation/reference/providers/repositories_provider/reference_repository_provider.dart';

part 'discussion_category_provider.g.dart';

@riverpod
class DiscussionCategory extends _$DiscussionCategory {
  @override
  Future<List<DiscussionCategoryModel>?> build() async {
    List<DiscussionCategoryModel>? categories;

    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(referenceRepositoryProvider)
          .getDiscussionCategories();

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) {
          categories = r;
          state = AsyncValue.data(r);
        },
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }

    return categories;
  }

  Future<void> createDiscussionCategory({required String name}) async {
    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(referenceRepositoryProvider)
          .createDiscussionCategory(name: name);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => ref.invalidateSelf(),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }

  Future<void> editDiscussionCategory(
      {required DiscussionCategoryModel category}) async {
    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(referenceRepositoryProvider)
          .editDiscussionCategory(category: category);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => ref.invalidateSelf(),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }

  Future<void> deleteDiscussionCategory({required int id}) async {
    try {
      state = const AsyncValue.loading();

      final result = await ref
          .watch(referenceRepositoryProvider)
          .deleteDiscussionCategory(id: id);

      result.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) => ref.invalidateSelf(),
      );
    } catch (e) {
      state = AsyncValue.error((e as Failure).message, StackTrace.current);
    }
  }
}
