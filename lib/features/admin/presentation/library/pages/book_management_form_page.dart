// Flutter imports:
import 'package:flutter/material.dart';
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';

class BookManagementFormPage extends StatelessWidget {
  final String title;
  final BookDetailModel? book;

  const BookManagementFormPage({
    super.key,
    required this.title,
    this.book,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BookManagementFormPageArgs {
  final String title;
  final BookDetailModel? book;

  const BookManagementFormPageArgs({
    required this.title,
    this.book,
  });
}
