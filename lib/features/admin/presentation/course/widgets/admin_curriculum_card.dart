// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/course_models/curriculum_model.dart';
import 'package:law_app/features/shared/providers/course_providers/curriculum_actions_provider.dart';
import 'package:law_app/features/shared/widgets/custom_icon_button.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class AdminCurriculumCard extends ConsumerWidget {
  final CurriculumModel curriculum;
  final VoidCallback? onTap;

  const AdminCurriculumCard({
    super.key,
    required this.curriculum,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWellContainer(
      width: double.infinity,
      color: scaffoldBackgroundColor,
      radius: 8,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          offset: const Offset(0, 1),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 16,
            child: SvgAsset(
              assetPath: AssetPath.getIcon('balance-scale.svg'),
              color: secondaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${curriculum.title}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium!.copyWith(
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SvgAsset(
                            assetPath: AssetPath.getIcon('clock-solid.svg'),
                            color: secondaryTextColor,
                            width: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${curriculum.curriculumDuration} menit',
                            style: textTheme.bodySmall!.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CustomIconButton(
                  iconName: 'pencil-line.svg',
                  color: infoColor,
                  size: 20,
                  onPressed: () => context.showSingleFormDialog(
                    title: 'Edit Nama Kurikulum',
                    name: 'title',
                    label: 'Nama Kurikulum',
                    hintText: 'Masukkan nama kurikulum',
                    initialValue: curriculum.title,
                    primaryButtonText: 'Edit',
                    onSubmitted: (value) {
                      navigatorKey.currentState!.pop();

                      ref
                          .read(curriculumActionsProvider.notifier)
                          .editCurriculum(
                            curriculum: curriculum.copyWith(
                              title: value['title'],
                            ),
                          );
                    },
                  ),
                  tooltip: 'Edit',
                ),
                CustomIconButton(
                  iconName: 'trash-line.svg',
                  color: errorColor,
                  size: 20,
                  onPressed: () => context.showConfirmDialog(
                    title: 'Hapus Kurikulum?',
                    message: 'Anda yakin ingin menghapus Kurikulum ini?',
                    primaryButtonText: 'Hapus',
                    onPressedPrimaryButton: () {
                      navigatorKey.currentState!.pop();

                      ref
                          .read(curriculumActionsProvider.notifier)
                          .deleteCurriculum(id: curriculum.id!);
                    },
                  ),
                  tooltip: 'Hapus',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
