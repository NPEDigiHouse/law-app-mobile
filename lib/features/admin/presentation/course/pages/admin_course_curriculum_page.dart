// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/admin/presentation/course/widgets/admin_curriculum_card.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCourseCurriculumPage extends StatelessWidget {
  final CourseDetail courseDetail;
  const AdminCourseCurriculumPage({super.key, required this.courseDetail});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        context.back();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFA2355A).withOpacity(.1),
                          const Color(0xFF730034).withOpacity(.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Image.asset(
                      AssetPath.getImage(courseDetail.image),
                      fit: BoxFit.fill,
                    ),
                  ),
                  AppBar(
                    automaticallyImplyLeading: false,
                    foregroundColor: scaffoldBackgroundColor,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    centerTitle: true,
                    title: Text(
                      'Progress Course',
                      style: textTheme.titleLarge!.copyWith(
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () => context.back(),
                      icon: SvgAsset(
                        assetPath: AssetPath.getIcon('caret-line-left.svg'),
                        color: scaffoldBackgroundColor,
                        width: 24,
                      ),
                      tooltip: 'Kembali',
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgAsset(
                              assetPath: AssetPath.getIcon('clock-solid.svg'),
                              color: accentTextColor,
                              width: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Total jam belajar sekitar ${courseDetail.completionTime} jam',
                                style: textTheme.bodyMedium!.copyWith(
                                  color: accentTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          courseDetail.title,
                          style: textTheme.headlineSmall!.copyWith(
                            color: scaffoldBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 8,
                      ),
                      child: Text(
                        'Kurikulum',
                        style: textTheme.titleMedium,
                      ),
                    ),
                    ...List<Padding>.generate(
                      courseDetail.curriculums.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: index == courseDetail.curriculums.length - 1
                              ? 0
                              : 10,
                        ),
                        child: AdminCurriculumCard(
                          curriculum: courseDetail.curriculums[index],
                          showDetail: true,
                          onTap: () => navigatorKey.currentState!.pushNamed(
                            adminCourseLessonRoute,
                            arguments: courseDetail.curriculums[index],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.showSingleFormDialog(
                        title: "Tambah Kurikulum",
                        name: "curriculum",
                        label: "Nama Kurikulum",
                        hintText: "Masukkan nama kurikulum",
                      ),
                      child: const Text('Tambah Kurikulum'),
                    ).fullWidth(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
