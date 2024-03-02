// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_detail_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/get_discussion_detail_provider.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_reply_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/shared/widgets/dialog/answer_question_dialog.dart';

class TeacherDiscussionDetailPage extends ConsumerWidget {
  final int id;

  const TeacherDiscussionDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discussion = ref.watch(GetDiscussionDetailProvider(id: id));

    return discussion.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (discussion) {
        if (discussion == null) return const Scaffold();

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
                    CircleProfileAvatar(
                      imageUrl: discussion.asker!.profilePicture,
                      radius: 20,
                    ),
                    const SizedBox(width: 8),
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
                            '${discussion.createdAt?.toStringPattern('d MMMM yyyy')}',
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
                      text: '${discussion.status?.toCapitalize()}',
                      color: FunctionHelper.getColorByDiscussionStatus(
                        discussion.status!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${discussion.category?.name}',
                  style: textTheme.bodySmall!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${discussion.title}',
                  style: textTheme.titleLarge!.copyWith(
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text('${discussion.description}'),
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
                      discussion.status == 'open'
                          ? 'Belum ada balasan'
                          : '${discussion.comments?.length} Balasan',
                      style: textTheme.titleMedium!.copyWith(
                        color: primaryColor,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                buildDiscussionSection(discussion, context: context),
                if (discussion.type == 'specific' &&
                    discussion.status == 'onDiscussion') ...[
                  const SizedBox(height: 12),
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
                    onPressed: () => context.showCustomAlertDialog(
                      title: 'Masalah Terjawab?',
                      message:
                          'Aksi ini sebaiknya dilakukan oleh Penanya. Pastikan bahwa Penanya sudah puas dengan jawaban yang diberikan!',
                      withCheckbox: true,
                      checkboxLabel:
                          'Saya memastikan Penanya puas dengan jawaban yang diberikan.',
                      foregroundColor: warningColor,
                      backgroundColor: const Color(0xFFFCF6DF),
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
      },
    );
  }

  Widget buildDiscussionSection(
    DiscussionDetailModel discussion, {
    required BuildContext context,
  }) {
    if (discussion.status == 'open') {
      if (discussion.type == 'specific') {
        return FilledButton(
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AnswerQuestionDialog(discussion: discussion);
            },
          ),
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
            comment: discussion.comments![index],
            asker: discussion.asker!,
            reverse: true,
          ),
        ),
      ),
    );
  }
}
