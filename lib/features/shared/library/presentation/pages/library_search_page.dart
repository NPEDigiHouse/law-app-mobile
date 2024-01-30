import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/library/presentation/widgets/book_card.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/text_field/search_field.dart';

class LibrarySearchPage extends StatefulWidget {
  const LibrarySearchPage({super.key});

  @override
  State<LibrarySearchPage> createState() => _LibrarySearchPageState();
}

class _LibrarySearchPageState extends State<LibrarySearchPage> {
  late final ValueNotifier<String> query;
  late List<Book> bookList;

  @override
  void initState() {
    super.initState();

    query = ValueNotifier('');
    bookList = books;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Cari Buku',
                  style: textTheme.titleMedium!.copyWith(
                    color: scaffoldBackgroundColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: query,
                builder: (context, query, child) {
                  return SearchField(
                    text: query,
                    hintText: 'Cari judul buku atau pengarang...',
                    autoFocus: true,
                    onChanged: searchTerm,
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
            return const CustomInformation(
              illustrationName: 'book-lover-cuate.svg',
              title: 'Hasil Pencarian Buku',
              subtitle: 'Hasil pencarian Anda akan muncul di sini',
            );
          }

          if (bookList.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Buku Tidak Ditemukan',
              subtitle: 'Buku dengan judul/pengarang tersebut tidak ditemukan',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            itemBuilder: (context, index) {
              return BookCard(
                book: bookList[index],
                onTap: () {},
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: bookList.length,
          );
        },
      ),
    );
  }

  void searchTerm(String query) {
    EasyDebounce.debounce(
      'search-debouncer',
      const Duration(milliseconds: 800),
      () {
        this.query.value = query;

        final result = books.where((book) {
          final queryLower = query.toLowerCase();
          final titleLower = book.title.toLowerCase();
          final authorLower = book.author.toLowerCase();

          return titleLower.contains(queryLower) ||
              authorLower.contains(queryLower);
        }).toList();

        setState(() => bookList = result);
      },
    );

    if (query.isEmpty) {
      EasyDebounce.fire('search-debouncer');
    }
  }
}
