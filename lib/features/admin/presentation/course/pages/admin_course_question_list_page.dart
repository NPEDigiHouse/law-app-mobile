// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseQuestionListPage extends StatelessWidget {
  final List<Item> items;

  const AdminCourseQuestionListPage({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Daftar Soal',
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
          onPressed: () =>
              navigatorKey.currentState!.pushNamed(adminCourseAddQuestionRoute),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('plus-line.svg'),
            color: secondaryColor,
            width: 32,
          ),
          tooltip: 'Tambah',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: List<InkWellContainer>.generate(
            items.length,
            (index) => InkWellContainer(
              onTap: () => navigatorKey.currentState!.pushNamed(
                  adminCourseAddQuestionRoute,
                  arguments: items[index]),
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
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      items[index].question,
                      maxLines: 2,
                      style: textTheme.titleSmall!.copyWith(
                        color: primaryColor,
                      ),
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
                        title: "Hapus Soal",
                        message: "Apakah Anda yakin ingin menghapus Soal ini?",
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
