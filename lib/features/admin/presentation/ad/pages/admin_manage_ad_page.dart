import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminManageAdPage extends StatelessWidget {
  const AdminManageAdPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {},
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('plus-line.svg'),
            color: secondaryColor,
            width: 32,
          ),
          tooltip: 'Kembali',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(),
        ),
      ),
    );
  }
}
