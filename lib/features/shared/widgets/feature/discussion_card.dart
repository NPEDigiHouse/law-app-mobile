import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';

class DiscussionCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Question question;
  final VoidCallback onTap;
  final bool isDetail;
  final bool withProfile;

  const DiscussionCard({
    super.key,
    this.width,
    this.height,
    required this.question,
    required this.onTap,
    this.isDetail = false,
    this.withProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      width: width,
      height: height,
      color: scaffoldBackgroundColor,
      radius: 12,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.1),
          offset: const Offset(2, 2),
          blurRadius: 4,
          spreadRadius: -1,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDetail) ...[
            Row(
              children: [
                if (withProfile)
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: secondaryColor,
                          child: CircleAvatar(
                            radius: 18,
                            foregroundImage: AssetImage(
                              AssetPath.getImage(question.owner.profilePict),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.owner.fullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleSmall,
                              ),
                              Text(
                                question.createdAt,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.labelSmall!.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Text(
                      question.category,
                      style: textTheme.bodySmall!.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                LabelChip(
                  text: question.status.toCapitalize(),
                  color: FunctionHelper.getColorByDiscussionStatus(
                    question.status,
                  ),
                ),
              ],
            ),
            SizedBox(height: withProfile ? 12 : 6),
          ],
          if (isDetail && withProfile) ...[
            Text(
              question.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall!.copyWith(
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 2),
          ],
          Text(
            question.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium!.copyWith(
              color: primaryColor,
              height: 0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            question.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall!.copyWith(
              color: primaryTextColor,
            ),
          ),
          if (isDetail && !withProfile) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                question.createdAt,
                style: textTheme.labelSmall!.copyWith(
                  color: secondaryTextColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
