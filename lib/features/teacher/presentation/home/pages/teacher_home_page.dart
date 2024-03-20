// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/dashboard.dart';
import 'package:law_app/features/shared/widgets/empty_content_text.dart';
import 'package:law_app/features/shared/widgets/feature/book_item.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/feature/home_page_header.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/teacher/presentation/home/providers/teacher_home_provider.dart';

class TeacherHomePage extends ConsumerWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(teacherHomeProvider);

    ref.listen(teacherHomeProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(teacherHomeProvider);
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
      body: homeData.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          final discussions = data.discussions;
          final books = data.books;

          if (discussions == null || books == null) return null;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomePageHeader(
                  child: Dashboard(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Perlu Dijawab',
                              style: textTheme.titleLarge!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => navigatorKey.currentState!.pushNamed(
                              teacherDiscussionListRoute,
                            ),
                            child: Text(
                              'Lihat Selengkapnya >',
                              style: textTheme.bodySmall!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (discussions.isEmpty)
                        const EmptyContentText(
                          'Pertanyaan khusus yang dialihkan dan belum dijawab akan muncul di sini.',
                        )
                      else
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return DiscussionCard(
                              discussion: discussions[index],
                              isDetail: true,
                              withProfile: true,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 8);
                          },
                          itemCount: discussions.length,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Buku Terbaru',
                              style: textTheme.titleLarge!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => navigatorKey.currentState!.pushNamed(
                              libraryBookListRoute,
                            ),
                            child: Text(
                              'Lihat Selengkapnya >',
                              style: textTheme.bodySmall!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (books.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          "Tingkatkan pengetahuanmu dengan buku-buku pilihan pakar untuk memperdalam ilmu kamu!",
                          style: textTheme.bodySmall!.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 24,
                  ),
                  child: books.isEmpty
                      ? const EmptyContentText(
                          'Daftar buku belum ada. Nantikan koleksi buku-buku dari kami ya.',
                        )
                      : SizedBox(
                          height: 210,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return BookItem(
                                height: 210,
                                width: 140,
                                titleMaxLines: 1,
                                book: books[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 8);
                            },
                            itemCount: books.length,
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
