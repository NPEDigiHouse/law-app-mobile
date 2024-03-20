// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseArticlePage extends StatelessWidget {
  final Article article;
  const AdminCourseArticlePage({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Detail Materi',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgAsset(
              assetPath: AssetPath.getIcon('read-outlined.svg'),
              color: primaryColor,
              width: 50,
            ),
            const SizedBox(height: 8),
            Text(
              article.title,
              style: textTheme.headlineSmall!.copyWith(
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgAsset(
                  assetPath: AssetPath.getIcon('clock-solid.svg'),
                  color: secondaryTextColor,
                  width: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Total durasi materi sekitar ${article.completionTime} menit',
                    style: textTheme.bodyMedium!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // TODO: show the content
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: secondaryColor,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: SvgAsset(
                            assetPath: AssetPath.getIcon('caret-line-left.svg'),
                            color: primaryColor,
                            width: 20,
                          ),
                          tooltip: 'Sebelumnya',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sebelumnya',
                        style: textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pelajaran 3: Proses Penerjemahan Dokumen Hukum',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: secondaryColor,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: SvgAsset(
                            assetPath: AssetPath.getIcon(
                              'caret-line-right.svg',
                            ),
                            color: primaryColor,
                            width: 20,
                          ),
                          tooltip: 'Selanjutnya',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Selanjutnya',
                        textAlign: TextAlign.end,
                        style: textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Quiz 2: Proses Penerjemahan Dokumen Hukum',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
