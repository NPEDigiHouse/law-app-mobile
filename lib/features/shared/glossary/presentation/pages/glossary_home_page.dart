import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/search_field.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class GlossaryHomePage extends StatelessWidget {
  const GlossaryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: HeaderContainer(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Glosarium',
                style: textTheme.headlineMedium!.copyWith(
                  color: accentTextColor,
                ),
              ),
              Text(
                'Cari definisi dari berbagai istilah hukum untuk memperkaya referensi dan pengetahuanmu!',
                style: textTheme.bodySmall!.copyWith(
                  color: scaffoldBackgroundColor,
                ),
              ),
              const SizedBox(height: 12),
              SearchField(
                text: '',
                hintText: 'Cari kosa kata...',
                readOnly: true,
                canRequestFocus: false,
                textInputAction: TextInputAction.none,
                onTap: () => navigatorKey.currentState!.pushNamed(
                  glossarySearchRoute,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SvgAsset(
                assetPath: AssetPath.getVector('house-searching-cuate.svg'),
                width: 260,
              ),
              const SizedBox(height: 12),
              Text(
                'Riwayat Pencarian',
                style: textTheme.headlineSmall!.copyWith(
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Riwayat pencarian Anda akan muncul di sini',
                style: textTheme.bodySmall!.copyWith(
                  color: primaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
