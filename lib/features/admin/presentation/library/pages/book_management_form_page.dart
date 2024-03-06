// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

final bookCoverProvider = StateProvider.autoDispose<File?>((ref) => null);
final bookFileProvider = StateProvider.autoDispose<File?>((ref) => null);

class BookManagementFormPage extends StatefulWidget {
  final String title;
  final List<BookCategoryModel> categories;
  final BookDetailModel? book;

  const BookManagementFormPage({
    super.key,
    required this.title,
    required this.categories,
    this.book,
  });

  @override
  State<BookManagementFormPage> createState() => _BookManagementFormPageState();
}

class _BookManagementFormPageState extends State<BookManagementFormPage> {
  final formKey = GlobalKey<FormBuilderState>();

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: widget.title,
          withBackButton: true,
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
            CustomTextField(
              initialValue: widget.book?.title,
              name: 'title',
              label: 'Judul Buku',
              hintText: 'Masukkan ',
            ),
          ],
        ),
      ),
    );
  }
}

class BookManagementFormPageArgs {
  final String title;
  final List<BookCategoryModel> categories;
  final BookDetailModel? book;

  const BookManagementFormPageArgs({
    required this.title,
    required this.categories,
    this.book,
  });
}
