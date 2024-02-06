import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/library/presentation/widgets/book_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class LibrarySavedBookPage extends StatelessWidget {
  const LibrarySavedBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Buku Disimpan',
          withBackButton: true,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        itemBuilder: (context, index) {
          return BookCard(book: books[index]);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
        itemCount: books.length,
      ),
    );
  }
}