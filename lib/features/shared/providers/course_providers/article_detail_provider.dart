// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/article_model.dart';
import 'package:law_app/features/shared/providers/course_providers/repositories_provider/course_repository_provider.dart';

part 'article_detail_provider.g.dart';

@riverpod
class ArticleDetail extends _$ArticleDetail {
  @override
  Future<ArticleModel?> build({required int id}) async {
    ArticleModel? article;

    state = const AsyncValue.loading();

    final result = await ref.watch(courseRepositoryProvider).getArticleDetail(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        article = r;
        state = AsyncValue.data(r);
      },
    );

    return article;
  }
}
