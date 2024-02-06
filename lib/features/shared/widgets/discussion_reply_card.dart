import 'package:flutter/material.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';

class DiscussionReplyCard extends StatelessWidget {
  final Question question;
  final User responder; // Will replaced with QuestionReply, soon!

  const DiscussionReplyCard({
    super.key,
    required this.question,
    required this.responder,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = question.owner == responder;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isOwner
          ? buildRowChildren(isOwner)
          : buildRowChildren(isOwner).reversed.toList(),
    );
  }

  List<Widget> buildRowChildren(bool isOwner) {
    return [
      CircleAvatar(
        radius: 16,
        backgroundColor: secondaryColor,
        child: CircleAvatar(
          radius: 14,
          foregroundImage: AssetImage(
            AssetPath.getImage(responder.profilePict),
          ),
        ),
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
                color: isOwner ? secondaryTextColor : tertiaryColor,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(12),
                bottomRight: const Radius.circular(12),
                topLeft: isOwner ? Radius.zero : const Radius.circular(12),
                topRight: !isOwner ? Radius.zero : const Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  responder.fullName,
                  style: textTheme.titleSmall,
                ),
                Text(
                  '15 menit yang lalu',
                  style: textTheme.labelSmall!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum.',
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
