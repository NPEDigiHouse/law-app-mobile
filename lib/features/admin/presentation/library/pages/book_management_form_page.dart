// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_dropdown_field.dart';
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
            Row(
              children: [],
            ),
            CustomTextField(
              name: 'title',
              label: 'Judul',
              hintText: 'Masukkan judul buku',
              initialValue: widget.book?.title,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(
              name: 'writer',
              label: 'Penulis',
              hintText: 'Masukkan nama penulis',
              initialValue: widget.book?.writer,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(
              name: 'publisher',
              label: 'Penerbit',
              hintText: 'Masukkan nama penerbit',
              initialValue: widget.book?.publisher,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomDropdownField(
              name: 'categoryId',
              label: 'Kategori',
              initialValue: widget.book?.category?.name,
              items: widget.categories.map((e) => e.name!).toList(),
              values: widget.categories.map((e) => e.id!.toString()).toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 20),
            CustomTextField(
              name: 'releaseDate',
              label: 'Tahun Terbit',
              hintText: 'd MMMM yyyy',
              initialValue:
                  widget.book?.releaseDate?.toStringPattern('d MMMM yyyy'),
              hasPrefixIcon: false,
              suffixIconName: 'calendar.svg',
              textInputType: TextInputType.none,
              validators: [
                FormBuilderValidators.required(
                  errorText: 'Bagian ini harus diisi',
                ),
              ],
              onTap: showReleaseDatePicker,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              name: 'synopsis',
              label: 'Sinopsis',
              hintText: 'Masukkan sinopsis buku',
              initialValue: widget.book?.synopsis,
              maxLines: 4,
              hasPrefixIcon: false,
              hasSuffixIcon: false,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              validators: [
                FormBuilderValidators.required(
                  errorText: "Bagian ini harus diisi",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showReleaseDatePicker() async {
    final releaseDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year - 50),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Buku Dirilis',
      locale: const Locale('id', 'ID'),
    );

    if (releaseDate != null) {
      date = releaseDate;

      final value = date.toStringPattern('d MMMM yyyy');

      formKey.currentState!.fields['releaseDate']!.didChange(value);
    }
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
