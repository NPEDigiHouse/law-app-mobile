// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/library/presentation/providers/book_provider.dart';
import 'package:law_app/features/shared/providers/manual_providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/book_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class LibrarySearchPage extends ConsumerWidget {
  const LibrarySearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);
    final books = ref.watch(BookProvider(query: query));

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
              SearchField(
                text: query,
                hintText: 'Cari judul buku',
                autoFocus: true,
                onChanged: (query) => searchBook(ref, query),
              ),
            ],
          ),
        ),
      ),
      body: books.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          final books = data.books;
          final hasMore = data.hasMore;

          if (books == null || hasMore == null) return null;

          if (books.isEmpty && query.trim().isNotEmpty) {
            return const CustomInformation(
              illustrationName: 'book-lover-cuate.svg',
              title: 'Buku tidak ditemukan',
              subtitle: 'Buku dengan judul tersebut tidak ditemukan.',
            );
          }

          if (books.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Belum ada buku',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            itemBuilder: (context, index) {
              if (index >= books.length) {
                return buildFetchMoreButton(ref, query, books.length);
              }

              return BookCard(book: books[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: hasMore ? books.length + 1 : books.length,
          );
        },
      ),
    );
  }

  TextButton buildFetchMoreButton(
    WidgetRef ref,
    String query,
    int currentLength,
  ) {
    return TextButton(
      onPressed: () {
        ref
            .read(BookProvider(
              query: query,
            ).notifier)
            .fetchMoreBooks(
              query: query,
              offset: currentLength,
            );
      },
      child: const Text('Lihat lebih banyak'),
    );
  }

  void searchBook(WidgetRef ref, String query) {
    if (query.trim().isNotEmpty) {
      ref.read(BookProvider(query: query));
    }

    ref.read(queryProvider.notifier).state = query;
  }
}
