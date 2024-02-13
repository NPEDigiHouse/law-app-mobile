import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/library/presentation/widgets/book_card.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/feature/book_item.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class LibraryHomePage extends StatelessWidget {
  const LibraryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Lanjutkan Membaca',
                style: textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 300,
                    child: BookCard(book: dummyBooks[index]),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemCount: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 20,
              ),
              child: Text(
                'Buku Populer',
                style: textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return BookItem(
                    width: 130,
                    titleMaxLines: 2,
                    book: dummyBooks[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemCount: dummyBooks.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 20,
              ),
              child: Text(
                'Daftar Buku',
                style: textTheme.titleLarge,
              ),
            ),
            GridView.count(
              primary: false,
              shrinkWrap: true,
              childAspectRatio: 2 / 3,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: List<Widget>.generate(
                dummyBooks.length,
                (index) => BookItem(book: dummyBooks[index]),
              )..add(
                  DottedBorder(
                    borderType: BorderType.RRect,
                    strokeCap: StrokeCap.round,
                    radius: const Radius.circular(8),
                    dashPattern: const [4, 4],
                    color: primaryColor,
                    child: GestureDetector(
                      onTap: () => navigatorKey.currentState!.pushNamed(
                        libraryBookListRoute,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Lihat lebih lengkap',
                              textAlign: TextAlign.center,
                              style: textTheme.titleSmall!.copyWith(
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SvgAsset(
                              assetPath: AssetPath.getIcon(
                                'caret-line-right.svg',
                              ),
                              color: primaryColor,
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
