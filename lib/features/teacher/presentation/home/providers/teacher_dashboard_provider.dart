// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/admin/data/models/dashboard_models/dashboard_data_model.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/auth/presentation/providers/dashboard_data_provider.dart';
import 'package:law_app/features/library/presentation/providers/repositories_provider/book_repository_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/repositories_provider/discussion_repository_provider.dart';

part 'teacher_dashboard_provider.g.dart';

@riverpod
class TeacherDashboard extends _$TeacherDashboard {
  @override
  Future<
      ({
        DashboardDataModel? dashboardData,
        List<DiscussionModel>? discussions,
        List<BookModel>? books,
      })> build() async {
    DashboardDataModel? dashboardData;
    List<DiscussionModel>? discussions;
    List<BookModel>? books;

    state = const AsyncValue.loading();

    final result = await ref
        .watch(discussionRepositoryProvider)
        .getDiscussions(type: 'specific', status: 'open');

    final result2 =
        await ref.watch(bookRepositoryProvider).getBooks(limit: kPageLimit);

    ref.listen(dashboardDataProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          this.state = AsyncValue.error(
            (error as Failure).message,
            StackTrace.current,
          );
        },
        data: (data) {
          dashboardData = data;

          result.fold(
            (l) {},
            (r) {
              discussions = r.where((e) {
                return CredentialSaver.user!.expertises!.contains(e.category);
              }).toList();

              if (discussions!.isNotEmpty) {
                discussions = discussions!.sublist(
                  0,
                  discussions!.length > 10 ? 10 : discussions!.length,
                );
              }
            },
          );

          result2.fold(
            (l) {},
            (r) => books = r,
          );

          this.state = AsyncValue.data((
            dashboardData: dashboardData,
            discussions: discussions,
            books: books,
          ));
        },
      );
    });

    return (
      dashboardData: dashboardData,
      discussions: discussions,
      books: books,
    );
  }
}