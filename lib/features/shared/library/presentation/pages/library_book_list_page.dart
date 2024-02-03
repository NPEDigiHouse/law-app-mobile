import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/library/presentation/widgets/book_category_chip.dart';
import 'package:law_app/features/shared/widgets/book_item.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class LibraryBookListPage extends StatefulWidget {
  const LibraryBookListPage({super.key});

  @override
  State<LibraryBookListPage> createState() => _LibraryBookListPageState();
}

class _LibraryBookListPageState extends State<LibraryBookListPage> {
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Daftar Buku',
          withBackButton: true,
          withTrailingButton: true,
          trailingButtonIconName: 'search-line.svg',
          trailingButtonTooltip: 'Cari',
          onPressedTrailingButton: () {},
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: -1,
                ),
              ],
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2 / 3,
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return BookItem(
                  book: books[index],
                  onTap: () {},
                );
              },
              itemCount: books.length,
            ),
          ),
        ],
      ),
    );
  }
}