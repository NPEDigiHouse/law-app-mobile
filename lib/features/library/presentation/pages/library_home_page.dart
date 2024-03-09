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
import 'package:law_app/features/library/presentation/providers/book_provider.dart';
import 'package:law_app/features/library/presentation/providers/library_provider.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/empty_content_text.dart';
import 'package:law_app/features/shared/widgets/feature/book_card.dart';
import 'package:law_app/features/shared/widgets/feature/book_item.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class LibraryHomePage extends ConsumerWidget {
  const LibraryHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(libraryProvider);

    ref.listen(libraryProvider, (_, state) {
      state.when(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                ref.invalidate(bookProvider);
                navigatorKey.currentState!.pop();
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () {},
        data: (_) {},
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(116),
        child: HeaderContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ruang Baca',
                      style: textTheme.headlineMedium!.copyWith(
                        color: accentTextColor,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomIconButton(
                        iconName: 'book-check.svg',
                        color: scaffoldBackgroundColor,
                        size: 28,
                        tooltip: 'Diselesaikan',
                        onPressed: () {
                          navigatorKey.currentState!.pushNamed(
                            libraryFinishedBookRoute,
                          );
                        },
                      ),
                      CustomIconButton(
                        iconName: 'bookmark-solid.svg',
                        color: scaffoldBackgroundColor,
                        size: 28,
                        tooltip: 'Disimpan',
                        onPressed: () {
                          navigatorKey.currentState!.pushNamed(
                            librarySavedBookRoute,
                          );
                        },
                      ),
                      CustomIconButton(
                        iconName: 'search-fill.svg',
                        color: scaffoldBackgroundColor,
                        size: 28,
                        tooltip: 'Cari',
                        onPressed: () {
                          navigatorKey.currentState!.pushNamed(
                            librarySearchRoute,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tingkatkan ilmu pengetahuanmu dengan membaca buku-buku pilihan!',
                style: textTheme.bodySmall!.copyWith(
                  color: scaffoldBackgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: books.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          final userReads = data.userReads;
          final books = data.books;

          if (books == null || userReads == null) return null;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Text(
                    'Lanjutkan Membaca',
                    style: textTheme.titleLarge!.copyWith(
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 300,
                        height: 120,
                        child: BookCard(book: userReads[index]),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 8);
                    },
                    itemCount: userReads.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Daftar Buku',
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
                ),
                if (books.isEmpty)
                  const EmptyContentText(
                    'Daftar buku masih kosong. Nantikan koleksi buku-buku dari kami ya.',
                  )
                else
                  GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    childAspectRatio: 2 / 3,
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 10,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: List<Widget>.generate(
                      books.length,
                      (index) => BookItem(book: books[index]),
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
