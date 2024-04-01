// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/course_material_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/material_model.dart';
import 'package:law_app/features/shared/providers/course_providers/article_actions_provider.dart';
import 'package:law_app/features/shared/providers/course_providers/quiz_actions_provider.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminMaterialCard extends ConsumerWidget {
  final MaterialModel material;
  final CourseMaterialType type;

  const AdminMaterialCard({
    super.key,
    required this.material,
    required this.type,
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
      onTap: () => navigatorKey.currentState!.pushNamed(
        type == CourseMaterialType.article
            ? adminCourseArticleRoute
            : adminCourseQuizRoute,
        arguments: material.id,
      ),
      child: Row(
        children: [
          SvgAsset(
            assetPath: AssetPath.getIcon(
              type == CourseMaterialType.article
                  ? 'read-outlined.svg'
                  : 'note-edit-line.svg',
            ),
            color: primaryColor,
            width: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${material.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium!.copyWith(
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 4),
          CustomIconButton(
            iconName: 'trash-line.svg',
            color: errorColor,
            size: 20,
            onPressed: () => context.showConfirmDialog(
              title: 'Hapus Materi?',
              message: 'Anda yakin ingin menghapus materi ini?',
              primaryButtonText: 'Hapus',
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();

                if (type == CourseMaterialType.article) {
                  ref
                      .read(articleActionsProvider.notifier)
                      .deleteArticle(id: material.id!);
                } else {
                  ref
                      .read(quizActionsProvider.notifier)
                      .deleteQuiz(id: material.id!);
                }
              },
            ),
            tooltip: 'Hapus',
          ),
        ],
      ),
    );
  }
}
