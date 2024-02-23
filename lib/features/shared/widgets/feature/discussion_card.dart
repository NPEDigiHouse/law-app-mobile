// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';

class DiscussionCard extends StatelessWidget {
  final String role;
  final Question question;
  final bool isDetail;
  final bool withProfile;
  final double? width;
  final double? height;

  const DiscussionCard({
    super.key,
    required this.role,
    required this.question,
    this.isDetail = false,
    this.withProfile = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      width: width,
      height: height,
      color: scaffoldBackgroundColor,
      radius: 12,
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
      onTap: onTap,
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
                        CircleProfileAvatar(
                          image: question.owner.profilePict,
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.owner.name,
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

  void onTap() {
    switch (role) {
      case 'admin':
        break;
      case 'student':
        navigatorKey.currentState!.pushNamed(
          studentDiscussionDetailRoute,
          arguments: question,
        );
        break;
      case 'teacher':
        navigatorKey.currentState!.pushNamed(
          teacherDiscussionDetailRoute,
          arguments: question,
        );
        break;
      default:
        break;
    }
  }
}
