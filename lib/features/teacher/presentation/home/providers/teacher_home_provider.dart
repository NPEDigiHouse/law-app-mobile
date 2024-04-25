// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'teacher_home_provider.g.dart';

@riverpod
class TeacherHome extends _$TeacherHome {
  @override
  Future<({List<DiscussionModel>? discussions, List<BookModel>? books})> build() async {
    List<DiscussionModel>? discussions;
    List<BookModel>? books;

    state = const AsyncValue.loading();

    final result = await ref.watch(discussionRepositoryProvider).getDiscussions(
          type: 'specific',
          status: 'open',
        );

    final result2 = await ref.watch(bookRepositoryProvider).getBooks(limit: kPageLimit);

    result.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) {
        discussions = r.where((e) {
          return CredentialSaver.user!.expertises!.contains(e.category);
        }).toList();

        if (discussions!.isNotEmpty) {
          discussions = discussions!.sublist(
            0,
            discussions!.length > 5 ? 5 : discussions!.length,
          );
        }

        result2.fold(
          (l) => state = AsyncValue.error(l.message, StackTrace.current),
          (r) {
            books = r;
            state = AsyncValue.data((discussions: discussions, books: books));
          },
        );
      },
    );

    return (discussions: discussions, books: books);
  }
}
