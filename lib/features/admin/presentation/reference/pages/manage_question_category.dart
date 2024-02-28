// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class ManageQuestionCategory extends StatelessWidget {
  const ManageQuestionCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Kategori Pertanyaan',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<InkWellContainer>.generate(
              3,
              (index) => InkWellContainer(
                radius: 12,
                color: scaffoldBackgroundColor,
                margin: EdgeInsets.only(bottom: index == 2 ? 0 : 8),
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
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: GradientColors.redPastel,
          ),
        ),
        child: IconButton(
          onPressed: () => context.showSingleFormDialog(
            title: "Tambah Kategori Pertanyaan",
            name: "question_category",
            label: "Kategori Pertanyaan",
            hintText: "Masukkan kategori pertanyaan",
            primaryButtonText: 'Tambah',
            onSubmitted: (value) {},
          ),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('plus-line.svg'),
            color: scaffoldBackgroundColor,
            width: 24,
          ),
          tooltip: 'Tambah',
        ),
      ),
    );
  }
}
