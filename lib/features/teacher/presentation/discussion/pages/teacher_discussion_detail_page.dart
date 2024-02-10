import 'package:flutter/material.dart';
import 'package:law_app/core/enums/question_status.dart';
import 'package:law_app/core/enums/question_type.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_reply_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class TeacherDiscussionDetailPage extends StatelessWidget {
  final Question question;

  const TeacherDiscussionDetailPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Detail Pertanyaan',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                const SizedBox(width: 8),
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
                const SizedBox(width: 8),
                LabelChip(
                  text: question.status.toCapitalize(),
                  color: FunctionHelper.getColorByDiscussionStatus(
                    question.status,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              question.category,
              style: textTheme.bodySmall!.copyWith(
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              question.title,
              style: textTheme.titleLarge!.copyWith(
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(question.description),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 8,
              ),
              child: Divider(
                color: Theme.of(context).dividerColor,
              ),
            ),
            Row(
              children: [
                SvgAsset(
                  assetPath: AssetPath.getIcon('chat-bubble-solid.svg'),
                  color: primaryColor,
                  width: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  question.status == QuestionStatus.open.name
                      ? 'Belum ada balasan'
                      : '5 Balasan',
                  style: textTheme.titleMedium!.copyWith(
                    color: primaryColor,
                    height: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            buildDiscussionSection(question.type, question.status),
            if (question.type == QuestionType.specific.name &&
                question.status == QuestionStatus.discuss.name) ...[
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {},
                child: const Text('Beri Tanggapan'),
              ).fullWidth(),
              FilledButton(
                onPressed: () => {},
                style: FilledButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: primaryColor,
                ),
                child: const Text('Masalah Terjawab'),
              ).fullWidth(),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildDiscussionSection(String type, String status) {
    if (status == QuestionStatus.open.name) {
      if (type == QuestionType.specific.name) {
        return FilledButton(
          onPressed: () {},
          child: const Text('Jawab Sekarang!'),
        ).fullWidth();
      }

      return const SizedBox();
    }

    return Column(
      children: List<Padding>.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == 4 ? 0 : 12),
          child: DiscussionReplyCard(
            questionOwner: question.owner,
            responder: index.isEven ? teacher : question.owner,
            reverse: true,
          ),
        ),
      ),
    );
  }
}
