import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

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
          withTrailingButton: true,
          trailingButtonIconName: 'trash-line.svg',
          trailingButtonTooltip: 'Hapus',
          onPressedTrailingButton: () {},
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
                  radius: 18,
                  backgroundColor: secondaryColor,
                  child: CircleAvatar(
                    radius: 20,
                    foregroundImage: AssetImage(
                      AssetPath.getImage(question.owner.profilePict),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                LabelChip(
                  text: question.status,
                  color: FunctionHelper.getColorByDiscussionStatus(
                    question.status,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                height: 0,
              ),
            ),
            const SizedBox(height: 8),
            Text(question.description),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 12,
              ),
              child: Divider(
                color: Theme.of(context).dividerColor,
              ),
            ),
            Row(
              children: [
                SvgAsset(
                  assetPath: AssetPath.getIcon('chat-bubble-solid.svg'),
                  width: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  question.status == 'Open' ? 'Belum ada balasan' : '3 Balasan',
                  style: textTheme.titleMedium!.copyWith(height: 0),
                ),
              ],
            ),
            const SizedBox(height: 12),
            buildDiscussionSection(question.status),
          ],
        ),
      ),
      bottomSheet: question.status == 'Discuss' ? buildActionButtons() : null,
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
      case 'discuss':
        return const SizedBox();
      case 'solved':
        return const SizedBox();
      default:
        return const SizedBox();
    }
  }

  Container buildActionButtons() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            spreadRadius: -1,
            color: Colors.black.withOpacity(.1),
          ),
        ],
        color: scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            onPressed: () {},
            child: const Text('Beri Tanggapan'),
          ).fullWidth(),
          const SizedBox(height: 4),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: primaryColor,
            ),
            child: const Text('Masalah Terjawab'),
          ).fullWidth(),
        ],
      ),
    );
  }
}
