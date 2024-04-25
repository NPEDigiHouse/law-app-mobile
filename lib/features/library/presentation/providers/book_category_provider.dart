// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'book_category_provider.g.dart';

@riverpod
class BookCategory extends _$BookCategory {
  @override
  Future<List<BookCategoryModel>?> build() async {
    List<BookCategoryModel>? categories;

    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).getBookCategories();

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        categories = r;
        state = AsyncValue.data(r);
      },
    );

    return categories;
  }

  Future<void> createBookCategory({required String name}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).createBookCategory(name: name);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<void> editBookCategory({required BookCategoryModel category}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).editBookCategory(category: category);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<void> deleteBookCategory({required int id}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(bookRepositoryProvider).deleteBookCategory(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }
}
