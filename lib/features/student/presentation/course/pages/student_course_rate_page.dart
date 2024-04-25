// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/course_detail_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/create_course_rating_provider.dart';
import 'package:law_app/features/shared/widgets/custom_network_image.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

final ratingProvider = StateProvider.autoDispose<int>((ref) => 0);

class StudentCourseRatePage extends ConsumerWidget {
  final CourseModel course;

  const StudentCourseRatePage({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();
    final rating = ref.watch(ratingProvider);

    ref.listen(createCourseRatingProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (message) {
          if (message != null) {
            ref.invalidate(courseDetailProvider);

            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop(message);
          }
        },
      );
    });

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
                        const Color(0xFFA2355A).withOpacity(.1),
                        const Color(0xFF730034).withOpacity(.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: course.coverImg!,
                    placeHolderSize: 64,
                    aspectRatio: 3 / 2,
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
                    '${course.title}',
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
                        onRatingUpdate: (value) {
                          ref.read(ratingProvider.notifier).state = value.toInt();
                        },
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
                      maxLines: 5,
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
          onPressed: () => submit(ref, formKey, rating),
          child: const Text('Submit Ulasan'),
        ).fullWidth(),
      ),
    );
  }

  void submit(WidgetRef ref, GlobalKey<FormBuilderState> formKey, int rating) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final comment = formKey.currentState!.value['comment'] as String?;

      if (rating == 0) return;

      ref.read(createCourseRatingProvider.notifier).createCourseRating(
            courseId: course.id!,
            rating: rating,
            comment: comment == null
                ? 'null'
                : comment.isEmpty
                    ? 'null'
                    : comment,
          );
    }
  }
}
