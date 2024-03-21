// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/article_detail_model.dart';
import 'package:law_app/features/admin/data/models/course_models/article_post_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'article_actions_provider.g.dart';

@riverpod
class ArticleActions extends _$ArticleActions {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createArticle({required ArticlePostModel article}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .watch(courseRepositoryProvider)
        .createArticle(article: article);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Berhasil menambahkan Artikel!'),
    );
  }

  Future<void> editArticle({required ArticleDetailModel article}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).editArticle(article: article);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Artikel berhasil diedit!'),
    );
  }

  Future<void> deleteArticle({required int id}) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(courseRepositoryProvider).deleteArticle(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = const AsyncValue.data('Artikel telah dihapus!'),
    );
  }
}
