import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminManageQuestionCategory extends StatelessWidget {
  const AdminManageQuestionCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "id": "1",
        "categoryName": "Hukum Tata Negara",
      },
      {
        "id": "2",
        "categoryName": "Hukum Perdata",
      },
      {
        "id": "3",
        "categoryName": "Hukum Internasional",
      },
      {
        "id": "4",
        "categoryName": "Hukum Material",
      },
      {
        "id": "5",
        "categoryName": "Hukum Formal",
      },
    ];
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Kategori Pertanyaan',
          withBackButton: true,
        ),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(colors: GradientColors.redPastel),
        ),
        child: IconButton(
          onPressed: () => context.showSingleFormDialog(
            title: "Tambah Kategori Pertanyaan",
            name: "question_category",
            label: "Kategori Pertanyaan",
            hintText: "Masukkan kategori pertanyaan",
          ),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('plus-line.svg'),
            color: secondaryColor,
            width: 32,
          ),
          tooltip: 'Tambah',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              items.length,
              (index) => InkWellContainer(
                margin: EdgeInsets.only(bottom: index == items.length ? 0 : 8),
                color: scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
                radius: 12,
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        items[index]["categoryName"],
                        maxLines: 2,
                        style: textTheme.titleSmall!,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: infoColor,
                          ),
                          child: IconButton(
                            onPressed: () => context.showSingleFormDialog(
                              title: "Tambah Kategori Pertanyaan",
                              name: "question_category",
                              label: "Kategori Pertanyaan",
                              hintText: "Masukkan kategori pertanyaan",
                            ),
                            icon: SvgAsset(
                              assetPath: AssetPath.getIcon('pencil-solid.svg'),
                              color: secondaryColor,
                              width: 32,
                            ),
                            tooltip: 'Edit',
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: errorColor,
                          ),
                          child: IconButton(
                            onPressed: () => context.showConfirmDialog(
                              title: "Hapus FAQ",
                              message:
                                  "Apakah Anda yakin ingin menghapus FAQ ini?",
                            ),
                            icon: SvgAsset(
                              assetPath: AssetPath.getIcon('trash-solid.svg'),
                              color: secondaryColor,
                              width: 32,
                            ),
                            tooltip: 'Hapus',
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
