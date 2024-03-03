// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_comment_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_model.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';

class DiscussionReplyCard extends StatelessWidget {
  final DiscussionCommentModel comment;
  final UserModel asker;
  final bool reverse;

  const DiscussionReplyCard({
    super.key,
    required this.comment,
    required this.asker,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    var isLeft = asker == comment.user!;

    if (reverse) isLeft = !isLeft;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isLeft
          ? buildRowChildren(comment, isLeft)
          : buildRowChildren(comment, isLeft).reversed.toList(),
    );
  }

  List<Widget> buildRowChildren(DiscussionCommentModel comment, bool isLeft) {
    return [
      CircleProfileAvatar(
        imageUrl: comment.user!.profilePicture,
        radius: 16,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: isLeft ? secondaryTextColor : tertiaryColor,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(12),
                bottomRight: const Radius.circular(12),
                topLeft: isLeft ? Radius.zero : const Radius.circular(12),
                topRight: !isLeft ? Radius.zero : const Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${comment.user?.name}',
                        style: textTheme.titleSmall,
                      ),
                    ),
                    if (comment.user!.role! != 'student') ...[
                      const SizedBox(width: 8),
                      LabelChip(
                        text: '${comment.user?.role?.toCapitalize()}',
                        color: FunctionHelper.getColorByRole(
                          comment.user!.role!,
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  timeago.format(comment.createdAt!),
                  style: textTheme.labelSmall!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${comment.text}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
