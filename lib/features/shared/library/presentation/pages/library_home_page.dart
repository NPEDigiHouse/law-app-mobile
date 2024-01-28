import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
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
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lanjutkan Membaca',
              style: textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
