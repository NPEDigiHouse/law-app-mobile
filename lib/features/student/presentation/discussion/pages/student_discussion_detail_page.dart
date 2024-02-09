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
import 'package:law_app/features/student/presentation/discussion/widgets/specific_question_info_dialog.dart';

class StudentDiscussionDetailPage extends StatelessWidget {
  final Question question;

  const StudentDiscussionDetailPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Detail Pertanyaan',
          withBackButton: true,
          withTrailingButton: question.owner == user,
          trailingButtonIconName: 'trash-line.svg',
          trailingButtonTooltip: 'Hapus',
          onPressedTrailingButton: () => context.showCustomAlertDialog(
            title: 'Hapus Pertanyaan?',
            message: 'Seluruh diskusi kamu dalam Pertanyaan ini akan dihapus!',
            primaryButtonText: 'Hapus',
            onPressedPrimaryButton: () {},
          ),
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
            Row(
              children: [
                Flexible(
                  child: Text(
                    question.category,
                    style: textTheme.bodySmall!.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                ),
                if (question.type == QuestionType.specific.name) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: CircleAvatar(
                      radius: 1.5,
                      backgroundColor: secondaryTextColor,
                    ),
                  ),
                  Text(
                    'Pertanyaan Khusus',
                    style: textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return const SpecificQuestionInfoDialog();
                      },
                    ),
                    child: SvgAsset(
                      assetPath: AssetPath.getIcon('info-circle-line.svg'),
                      color: primaryTextColor,
                      width: 12,
                    ),
                  ),
                ],
              ],
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: buildDiscussionSection(question.status),
            ),
            if (question.status == QuestionStatus.discuss.name) ...[
              FilledButton(
                onPressed: () => context.showSingleFormDialog(
                  title: 'Beri Tanggapan',
                  name: 'response',
                  label: 'Tanggapan',
                  hintText: 'Masukkan tanggapan kamu',
                  maxLines: 4,
                  primaryButtonText: 'Submit',
                  onSubmitted: (value) {},
                ),
                child: const Text('Beri Tanggapan'),
              ).fullWidth(),
              FilledButton(
                onPressed: () => context.showConfirmDialog(
                  title: 'Masalah Terjawab',
                  message:
                      'Apakah kamu puas dengan jawaban yang diberikan? Aksi ini akan menutup diskusi kamu!',
                  withCheckbox: true,
                  checkboxLabel: 'Saya puas dengan jawaban yang diberikan.',
                  onPressedPrimaryButton: () {},
                ),
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

  Widget buildDiscussionSection(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Text(
          'Pertanyaan kamu akan segera dijawab oleh Admin atau Pakar kami.',
          style: textTheme.bodyMedium!.copyWith(
            color: secondaryTextColor,
          ),
        );
      case 'discuss' || 'solved':
        return Column(
          children: List<Padding>.generate(
            5,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == 5 ? 0 : 16),
              child: DiscussionReplyCard(
                question: question,
                responder: index.isEven ? teacher : question.owner,
              ),
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
