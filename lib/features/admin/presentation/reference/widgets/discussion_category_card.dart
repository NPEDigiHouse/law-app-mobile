// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';

class DiscussionCategoryCard extends StatelessWidget {
  const DiscussionCategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: scaffoldBackgroundColor,
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
              '',
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
                  title: "Edit Kategori Pertanyaan",
                  name: "name",
                  label: "Kategori Pertanyaan",
                  hintText: "Masukkan kategori pertanyaan",
                  initialValue: '',
                  primaryButtonText: 'Simpan',
                  onSubmitted: (value) {},
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
                  onPressedPrimaryButton: () {},
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
