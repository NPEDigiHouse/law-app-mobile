import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/library/presentation/widgets/book_card.dart';
import 'package:law_app/features/shared/widgets/book_item.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
                itemCount: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Buku Populer',
                style: textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return BookItem(
                    width: 120,
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Daftar Buku',
                style: textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
