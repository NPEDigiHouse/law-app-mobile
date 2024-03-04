// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/feature/book_card.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class LibrarySearchPage extends StatefulWidget {
  const LibrarySearchPage({super.key});

  @override
  State<LibrarySearchPage> createState() => _LibrarySearchPageState();
}

class _LibrarySearchPageState extends State<LibrarySearchPage> {
  late final ValueNotifier<String> query;
  late List<Book> books;
  late List<Book> bookHistoryList;

  @override
  void initState() {
    super.initState();

    query = ValueNotifier('');
    books = dummyBooks;
    bookHistoryList = dummyBooks.sublist(0, 3);
  }

  @override
  void dispose() {
    super.dispose();

    query.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(124),
        child: HeaderContainer(
          child: Column(
            children: [
              Text(
                'Cari Buku',
                style: textTheme.titleMedium!.copyWith(
                  color: scaffoldBackgroundColor,
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: query,
                builder: (context, query, child) {
                  return SearchField(
                    text: query,
                    hintText: 'Cari judul buku atau pengarang',
                    autoFocus: true,
                    onChanged: searchBook,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (query.value.isEmpty) {
            if (bookHistoryList.isEmpty) {
              return const CustomInformation(
                illustrationName: 'house-searching-cuate.svg',
                title: 'Riwayat pencarian',
                subtitle: 'Riwayat pencarian buku masih kosong.',
              );
            }

            return buildBookHistoryList();
          }

          if (books.isEmpty) {
            return const CustomInformation(
              illustrationName: 'book-lover-cuate.svg',
              title: 'Buku tidak ditemukan',
              subtitle: 'Buku dengan judul/pengarang tersebut tidak ditemukan.',
            );
          }

          return buildBookResultList();
        },
      ),
    );
  }

  CustomScrollView buildBookHistoryList() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '*Swipe ke samping untuk menghapus history buku',
                  style: textTheme.labelSmall!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Riwayat Pencarian',
                        style: textTheme.titleLarge,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.showConfirmDialog(
                        title: 'Konfirmasi',
                        message:
                            'Anda yakin ingin menghapus seluruh riwayat pencarian?',
                        onPressedPrimaryButton: () {},
                      ),
                      child: Text(
                        'Hapus Semua',
                        style: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Dismissible(
                  key: ValueKey<String>(bookHistoryList[index].title),
                  onDismissed: (_) {
                    setState(() {
                      bookHistoryList.removeWhere((book) {
                        return book.title == bookHistoryList[index].title;
                      });
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: BookCard(
                      isThreeLine: false,
                      book: bookHistoryList[index],
                    ),
                  ),
                );
              },
              childCount: bookHistoryList.length,
            ),
          ),
        ),
      ],
    );
  }

  ListView buildBookResultList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 20,
      ),
      itemBuilder: (context, index) {
        return BookCard(
          isThreeLine: false,
          book: books[index],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemCount: books.length,
    );
  }

  void searchBook(String query) {
    this.query.value = query;

    EasyDebounce.debounce(
      'search-debouncer',
      const Duration(milliseconds: 800),
      () {
        final result = dummyBooks.where((book) {
          final queryLower = query.toLowerCase();
          final titleLower = book.title.toLowerCase();
          final authorLower = book.author.toLowerCase();

          return titleLower.contains(queryLower) ||
              authorLower.contains(queryLower);
        }).toList();

        setState(() => books = result);
      },
    );

    if (query.isEmpty) {
      EasyDebounce.fire('search-debouncer');
    }
  }
}
