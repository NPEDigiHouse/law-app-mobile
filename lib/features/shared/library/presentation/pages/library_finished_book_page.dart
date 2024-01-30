import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/library/presentation/widgets/book_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class LibraryFinishedBookPage extends StatelessWidget {
  const LibraryFinishedBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final completeBooks =
        books.where((e) => e.completePercentage == 100).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Selesai Dibaca',
          withBackButton: true,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        itemBuilder: (context, index) {
          return BookCard(
            book: completeBooks[index],
            onTap: () {},
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemCount: completeBooks.length,
      ),
    );
  }
}
