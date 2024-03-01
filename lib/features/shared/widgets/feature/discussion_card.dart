// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';

class DiscussionCard extends StatelessWidget {
  final DiscussionModel discussion;
  final bool isDetail;
  final bool withProfile;
  final double? width;
  final double? height;

  const DiscussionCard({
    super.key,
    required this.discussion,
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
                          imageUrl: discussion.asker?.profilePicture,
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${discussion.asker?.name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleSmall,
                              ),
                              Text(
                                timeago.format(discussion.createdAt!),
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
                      '${discussion.category?.name}',
                      style: textTheme.bodySmall!.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                LabelChip(
                  text: '${discussion.status?.toCapitalize()}',
                  color: FunctionHelper.getColorByDiscussionStatus(
                    discussion.status!,
                  ),
                ),
              ],
            ),
            SizedBox(height: withProfile ? 12 : 6),
          ],
          if (isDetail && withProfile) ...[
            Row(
              children: [
                Flexible(
                  child: Text(
                    '${discussion.category?.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                ),
                if (discussion.type == 'specific')
                  Text(
                    ' • Pertanyaan Khusus',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall!.copyWith(
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
          ],
          Text(
            '${discussion.title}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium!.copyWith(
              color: primaryColor,
              height: 0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${discussion.description}',
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
                timeago.format(discussion.createdAt!),
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
    switch (CredentialSaver.user!.role) {
      case 'admin':
        navigatorKey.currentState!.pushNamed(
          adminDiscussionDetailRoute,
          arguments: discussion.id,
        );
        break;
      case 'student':
        navigatorKey.currentState!.pushNamed(
          studentDiscussionDetailRoute,
          arguments: discussion.id,
        );
        break;
      case 'teacher':
        navigatorKey.currentState!.pushNamed(
          teacherDiscussionDetailRoute,
          arguments: discussion.id,
        );
        break;
      default:
        break;
    }
  }
}
