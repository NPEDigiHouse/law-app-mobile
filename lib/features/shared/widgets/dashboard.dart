// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/admin/data/models/dashboard_models/dashboard_data_model.dart';
import 'package:law_app/features/auth/presentation/providers/dashboard_data_provider.dart';
import 'package:law_app/features/shared/widgets/gradient_background_icon.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardData = ref.watch(dashboardDataProvider);

    return Container(
      height: 146,
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(2, 2),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ],
      ),
      child: dashboardData.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (dashboardData) {
          if (dashboardData == null) return null;

          final items = getItems(dashboardData);

          return Center(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    width: 84,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GradientBackgroundIcon(
                          icon: '${items[index]["icon"]}',
                          size: 56,
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            '${items[index]["count"]}',
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium!.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${items[index]["text"]}',
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall!.copyWith(height: 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<Map<String, Object?>> getItems(DashboardDataModel dashboardData) {
    switch (CredentialSaver.user!.role) {
      case 'admin':
        return [
          {
            "icon": "dictionary-book-solid.svg",
            "count": dashboardData.totalWords,
            "text": "Total\nGlosarium",
          },
          {
            "icon": "book-bold.svg",
            "count": dashboardData.totalBooks,
            "text": "Total\nBuku",
          },
          {
            "icon": "user-solid.svg",
            "count": dashboardData.totalUsers,
            "text": "Total\nPengguna",
          },
          {
            "icon": "question-circle-line.svg",
            "count": dashboardData.totalDiscussions,
            "text": "Total\nPertanyaan",
          }
        ];
      case 'teacher':
        return [
          {
            "icon": "question-circle-line.svg",
            "count": dashboardData.totalDiscussions,
            "text": "Pertanyaan\nDijawab",
          },
          {
            "icon": "book-bold.svg",
            "count": dashboardData.totalBooksRead,
            "text": "Buku\nDibaca",
          },
        ];
      case 'student':
        return [
          // {
          //   "icon": "chalkboard-teacher-fill.svg",
          //   "count": dashboardData.totalCourses,
          //   "text": "Course\nDiambil",
          // },
          {
            "icon": "question-circle-line.svg",
            "count": dashboardData.totalDiscussions,
            "text": "Pertanyaan\nDipakai",
          },
          {
            "icon": "book-bold.svg",
            "count": dashboardData.totalBooksRead,
            "text": "Buku\nDibaca",
          },
        ];
      default:
        return [];
    }
  }
}
