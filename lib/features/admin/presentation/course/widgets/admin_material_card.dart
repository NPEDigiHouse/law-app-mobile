// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/enums/course_material_type.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/material_model.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminMaterialCard extends StatelessWidget {
  final MaterialModel material;
  final CourseMaterialType type;

  const AdminMaterialCard({
    super.key,
    required this.material,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      width: double.infinity,
      color: scaffoldBackgroundColor,
      radius: 6,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          offset: const Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
      onTap: () => navigatorKey.currentState!.pushNamed(
        type == CourseMaterialType.article
            ? adminCourseArticleRoute
            : adminCourseQuizHomeRoute,
        arguments: material.id,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        child: Row(
          children: [
            SvgAsset(
              assetPath: AssetPath.getIcon(
                type == CourseMaterialType.article
                    ? 'read-outlined.svg'
                    : 'note-edit-line.svg',
              ),
              color: primaryTextColor,
              width: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text('${material.title}'),
            ),
          ],
        ),
      ),
    );
  }
}
