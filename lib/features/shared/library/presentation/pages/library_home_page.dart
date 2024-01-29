import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/library/presentation/widgets/book_card.dart';
import 'package:law_app/features/shared/library/presentation/widgets/book_category_chip.dart';
import 'package:law_app/features/shared/widgets/book_item.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class LibraryHomePage extends StatefulWidget {
  const LibraryHomePage({super.key});

  @override
  State<LibraryHomePage> createState() => _LibraryHomePageState();
}

class _LibraryHomePageState extends State<LibraryHomePage> {
  late final List<String> bookCategories;
  late final ValueNotifier<String> selectedCategory;

  @override
  void initState() {
    super.initState();

    bookCategories = [
      'Semua',
      'Pidana',
      'Tata Negara',
      'Syariah',
      'Lainnya',
    ];

    selectedCategory = ValueNotifier(bookCategories[0]);
  }

  @override
  void dispose() {
    super.dispose();

    selectedCategory.dispose();
  }

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
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
                        onPressed: () {},
                      ),
                      CustomIconButton(
                        iconName: 'bookmark-solid.svg',
                        color: scaffoldBackgroundColor,
                        size: 28,
                        tooltip: 'Disimpan',
                        onPressed: () {},
                      ),
                      CustomIconButton(
                        iconName: 'search-fill.svg',
                        color: scaffoldBackgroundColor,
                        size: 28,
                        tooltip: 'Cari',
                        onPressed: () {},
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
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
                    child: BookCard(
                      book: books[index],
                      onTap: () {},
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 12);
                },
                itemCount: books.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Text(
                'Buku Populer',
                style: textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return BookItem(
                    width: 130,
                    book: books[index],
                    onTap: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 12);
                },
                itemCount: books.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text(
                'Daftar Buku',
                style: textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                    valueListenable: selectedCategory,
                    builder: (context, category, child) {
                      final selected = category == bookCategories[index];

                      return BookCategoryChip(
                        label: bookCategories[index],
                        selected: selected,
                        onSelected: (_) {
                          selectedCategory.value = bookCategories[index];
                        },
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemCount: bookCategories.length,
              ),
            ),
            GridView.count(
              primary: false,
              shrinkWrap: true,
              childAspectRatio: 2 / 3,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: List<Widget>.generate(
                books.length,
                (index) => BookItem(
                  book: books[index],
                  onTap: () {},
                ),
              )..add(
                  DottedBorder(
                    borderType: BorderType.RRect,
                    strokeCap: StrokeCap.round,
                    radius: const Radius.circular(8),
                    color: primaryColor,
                    dashPattern: const [4, 4],
                    child: GestureDetector(
                      onTap: () => debugPrint('test'),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
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
