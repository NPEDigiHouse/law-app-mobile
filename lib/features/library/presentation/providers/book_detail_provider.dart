// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';

part 'book_detail_provider.g.dart';

@riverpod
class BookDetail extends _$BookDetail {
  @override
  Future<BookDetailModel?> build({required int id}) async {
    BookDetailModel? bookDetail;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(bookRepositoryProvider).getBookDetail(id: id);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        bookDetail = r;
        state = AsyncValue.data(r);
      },
    );

    return bookDetail;
  }
}
