// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class StudentCourseRatePage extends StatelessWidget {
  final CourseDetail courseDetail;

  const StudentCourseRatePage({super.key, required this.courseDetail});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
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
                        const Color(0xFFF4847D).withOpacity(.4),
                        const Color(0xFFE44C42).withOpacity(.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
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
                    'Beri Penilaian',
                    style: textTheme.titleLarge!.copyWith(
                      color: scaffoldBackgroundColor,
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
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
                  child: Text(
                    courseDetail.title,
                    style: textTheme.headlineSmall!.copyWith(
                      color: scaffoldBackgroundColor,
                    ),
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
                  const Text(
                    'Anda telah menyelesaikan course ini. Berikan rating dan tanggapanmu terhadap course ini untuk menjadi peningkatan terhadap course-course lainnya.',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: RatingBar(
                        glow: false,
                        minRating: 1,
                        itemSize: 48,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                        onRatingUpdate: (value) {},
                        ratingWidget: RatingWidget(
                          full: SvgAsset(
                            assetPath: AssetPath.getIcon('star-solid.svg'),
                            color: primaryColor,
                          ),
                          half: SvgAsset(
                            assetPath: AssetPath.getIcon('star-solid.svg'),
                          ),
                          empty: SvgAsset(
                            assetPath: AssetPath.getIcon('star-solid.svg'),
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  FormBuilder(
                    key: formKey,
                    child: const CustomTextField(
                      name: 'comment',
                      label: 'Beri komentar terkait course ini',
                      hintText: 'Coursenya bagus...',
                      hasPrefixIcon: false,
                      hasSuffixIcon: false,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: FilledButton(
          onPressed: () => submit(formKey),
          child: const Text('Dapatkan Sertifikat'),
        ).fullWidth(),
      ),
    );
  }

  void submit(GlobalKey<FormBuilderState> formKey) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      debugPrint(data.toString());
    }
  }
}
