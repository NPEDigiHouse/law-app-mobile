import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseQuizHomePage extends StatelessWidget {
  final Quiz quiz;
  const AdminCourseQuizHomePage({
    super.key,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Quiz',
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
            SvgAsset(
              assetPath: AssetPath.getIcon('note-edit-line.svg'),
              color: primaryColor,
              width: 50,
            ),
            const SizedBox(height: 8),
            Text(
              quiz.title,
              style: textTheme.headlineSmall!.copyWith(
                color: primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 16,
              ),
              child: Text(quiz.description),
            ),
            buildQuizInfoText(
              title: 'Total Soal',
              value: '${quiz.items.length} Soal',
            ),
            buildQuizInfoText(
              title: 'Waktu Pengerjaan',
              value: '${quiz.completionTime} Menit',
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                navigatorKey.currentState!.pushNamed(
                    adminCourseQuestionListRoute,
                    arguments: quiz.items);
              },
              style: FilledButton.styleFrom(
                foregroundColor: secondaryColor,
                backgroundColor: primaryColor,
              ),
              child: const Text("Lihat Daftar Soal"),
            ).fullWidth(),
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

  Padding buildQuizInfoText({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(title),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: textTheme.titleSmall!.copyWith(
                color: valueColor ?? primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildQuizHistoryInfoText({
    required Score score,
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              score.dateObtained.toStringPattern('yyyy-MM-dd, HH:mm'),
              style: textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              score.status.toCapitalize(),
              style: textTheme.bodySmall!.copyWith(
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${score.value}/100',
              style: textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Color? getColorByScoreStatus(String status) {
    switch (status) {
      case 'passed':
        return successColor;
      case 'failed':
        return errorColor;
      default:
        return null;
    }
  }
}
