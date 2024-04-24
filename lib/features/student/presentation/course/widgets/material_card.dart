// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/course_material_type.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/material_model.dart';
import 'package:law_app/features/admin/data/models/course_models/user_course_model.dart';
import 'package:law_app/features/shared/providers/course_providers/user_course_actions_provider.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/student/presentation/course/pages/student_course_article_page.dart';

class MaterialCard extends ConsumerWidget {
  final UserCourseModel userCourse;
  final int materialSequenceNumber;
  final MaterialModel material;
  final CourseMaterialType type;
  final bool isCompleted;
  final bool isLocked;
  final bool isLast;

  const MaterialCard({
    super.key,
    required this.userCourse,
    required this.materialSequenceNumber,
    required this.material,
    required this.type,
    this.isCompleted = false,
    this.isLocked = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWellContainer(
      color: scaffoldBackgroundColor,
      radius: 8,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
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
      onTap: isLocked
          ? null
          : () {
              if (isLast) {
                updateCurriculumSequence(ref);
              } else if (materialSequenceNumber ==
                  userCourse.currentMaterialSequence) {
                updateMaterialSequence(ref);
              }

              navigatorKey.currentState!.pushNamed(
                type == CourseMaterialType.article
                    ? studentCourseArticleRoute
                    : adminCourseQuizRoute,
                arguments: type == CourseMaterialType.article
                    ? StudentCourseArticlePageArgs(
                        id: material.id!,
                        materialSequenceNumber: materialSequenceNumber,
                        userCourse: userCourse,
                        isLastMaterial: isLast,
                      )
                    : null,
              );
            },
      child: Row(
        children: [
          if (isCompleted)
            const Icon(
              Icons.verified_rounded,
              color: successColor,
              size: 22,
            )
          else
            SvgAsset(
              assetPath: AssetPath.getIcon(
                type == CourseMaterialType.article
                    ? 'read-outlined.svg'
                    : 'note-edit-line.svg',
              ),
              color:
                  isLocked ? secondaryTextColor.withOpacity(.7) : primaryColor,
              width: 20,
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${material.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium!.copyWith(
                color: isLocked
                    ? secondaryTextColor.withOpacity(.7)
                    : primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateMaterialSequence(WidgetRef ref) {
    ref.read(userCourseActionsProvider.notifier).updateUserCourse(
          id: userCourse.id!,
          currentCurriculumSequence: userCourse.currentCurriculumSequence!,
          currentMaterialSequence: materialSequenceNumber + 1,
        );
  }

  void updateCurriculumSequence(WidgetRef ref) {
    ref.read(userCourseActionsProvider.notifier).updateUserCourse(
          id: userCourse.id!,
          currentCurriculumSequence: userCourse.currentCurriculumSequence! + 1,
          currentMaterialSequence: 0,
        );
  }
}
