// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/auth/presentation/providers/dashboard_data_provider.dart';
import 'package:law_app/features/shared/widgets/dashboard.dart';
import 'package:law_app/features/shared/widgets/feature/home_page_header.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardData = ref.watch(dashboardDataProvider);

    final menu = [
      {
        "icon": "user-solid.svg",
        "text": "Master Data",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(masterDataHomeRoute);
        },
      },
      {
        "icon": "question-circle-fill.svg",
        "text": "Kelola Pertanyaan",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(adminDiscussionHomeRoute);
        },
      },
      {
        "icon": "chalkboard-teacher-fill.svg",
        "text": "Kelola Course",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(adminCourseHomeRoute);
        },
      },
      {
        "icon": "book-bold.svg",
        "text": "Kelola Buku",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(bookManagementHomeRoute);
        },
      },
      {
        "icon": "dictionary-book-solid.svg",
        "text": "Kelola Glosarium",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(glossaryManagementRoute);
        },
      },
      {
        "icon": "link-line.svg",
        "text": "Referensi",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(referenceRoute);
        },
      },
      {
        "icon": "ads-icon.svg",
        "text": "Kelola Ads",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(adManagementHomeRoute);
        },
      },
    ];

    ref.listen(dashboardDataProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(dashboardDataProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: dashboardData.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (dashboardData) {
          if (dashboardData == null) return null;

          final items = [
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
            },
          ];

          return SingleChildScrollView(
            child: Column(
              children: [
                HomePageHeader(
                  child: Dashboard(items: items),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 6 / 5,
                    children: List<InkWellContainer>.generate(
                      menu.length,
                      (index) => InkWellContainer(
                        color: scaffoldBackgroundColor,
                        radius: 12,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                            spreadRadius: -1,
                          ),
                        ],
                        onTap: menu[index]["onTap"]! as VoidCallback,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: secondaryColor,
                              ),
                              child: SvgAsset(
                                color: primaryColor,
                                assetPath: AssetPath.getIcon(
                                  menu[index]["icon"]! as String,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: Text(
                                menu[index]["text"]! as String,
                                style: textTheme.titleMedium!.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
