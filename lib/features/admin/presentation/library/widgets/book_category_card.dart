// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';
import 'package:law_app/features/library/presentation/providers/book_category_provider.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';

class BookCategoryCard extends ConsumerWidget {
  final BookCategoryModel category;

  const BookCategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWellContainer(
      color: scaffoldBackgroundColor,
      radius: 10,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.1),
          offset: const Offset(0, 1),
          blurRadius: 4,
          spreadRadius: -1,
        ),
      ],
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${category.name}',
              style: textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                iconName: 'pencil-line.svg',
                color: infoColor,
                size: 20,
                onPressed: () => context.showSingleFormDialog(
                  title: "Edit Kategori Buku",
                  name: "name",
                  label: "Kategori",
                  hintText: "Masukkan nama kategori",
                  initialValue: category.name,
                  primaryButtonText: 'Simpan',
                  onSubmitted: (value) {
                    final newCategory = category.copyWith(name: value['name']);

                    navigatorKey.currentState!.pop();

                    ref.read(bookCategoryProvider.notifier).editBookCategory(category: newCategory);
                  },
                ),
                tooltip: 'Edit',
              ),
              CustomIconButton(
                iconName: 'trash-line.svg',
                color: errorColor,
                size: 20,
                onPressed: () => context.showConfirmDialog(
                  title: "Konfirmasi",
                  message: "Anda yakin ingin menghapus kategori ini?",
                  primaryButtonText: 'Hapus',
                  onPressedPrimaryButton: () {
                    navigatorKey.currentState!.pop();

                    ref.read(bookCategoryProvider.notifier).deleteBookCategory(id: category.id!);
                  },
                ),
                tooltip: 'Hapus',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
