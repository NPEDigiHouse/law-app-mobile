// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/extensions/string_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_detail_model.dart';
import 'package:law_app/features/shared/providers/discussion_providers/create_discussion_comment_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/delete_discussion_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/discussion_detail_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/edit_discussion_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/student_discussions_provider.dart';
import 'package:law_app/features/shared/providers/discussion_providers/user_discussions_provider.dart';
import 'package:law_app/features/shared/widgets/circle_profile_avatar.dart';
import 'package:law_app/features/shared/widgets/dialog/specific_discussion_info_dialog.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_reply_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/label_chip.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class StudentDiscussionDetailPage extends ConsumerWidget {
  final int id;

  const StudentDiscussionDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discussion = ref.watch(DiscussionDetailProvider(id: id));

    ref.listen(DiscussionDetailProvider(id: id), (_, state) {
      state.when(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(discussionDetailProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () {},
        data: (_) {},
      );
    });

    ref.listen(deleteDiscussionProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (data) {
          if (data != null) {
            ref.invalidate(userDiscussionsProvider);
            ref.invalidate(studentDiscussionsProvider);

            context.showBanner(
              message: 'Pertanyaan kamu berhasil dihapus!',
              type: BannerType.success,
            );

            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
          }
        },
      );
    });

    ref.listen(editDiscussionProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (data) {
          if (data != null) {
            ref.invalidate(DiscussionDetailProvider(id: id));
            ref.invalidate(userDiscussionsProvider);
            ref.invalidate(studentDiscussionsProvider);

            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
          }
        },
      );
    });

    ref.listen(createDiscussionCommentProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (data) {
          if (data != null) {
            ref.invalidate(DiscussionDetailProvider(id: id));

            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
          }
        },
      );
    });

    return discussion.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (discussion) {
        if (discussion == null) return const Scaffold();

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(96),
            child: HeaderContainer(
              title: 'Detail Pertanyaan',
              withBackButton: true,
              withTrailingButton:
                  discussion.asker!.id == CredentialSaver.user!.id,
              trailingButtonIconName: 'trash-line.svg',
              trailingButtonTooltip: 'Hapus',
              onPressedTrailingButton: () => context.showCustomAlertDialog(
                title: 'Hapus Pertanyaan?',
                message:
                    'Seluruh diskusi kamu dalam Pertanyaan ini akan dihapus!',
                primaryButtonText: 'Hapus',
                onPressedPrimaryButton: () {
                  ref
                      .read(deleteDiscussionProvider.notifier)
                      .deleteDiscussion(id: id);
                },
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
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${discussion.category?.name}',
                        style: textTheme.bodySmall!.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                    if (discussion.type == 'specific') ...[
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
                          barrierDismissible: false,
                          builder: (context) {
                            return const SpecificDiscussionInfoDialog();
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
                buildDiscussionSection(discussion),
                if (discussion.asker!.id == CredentialSaver.user!.id &&
                    discussion.status == 'onDiscussion') ...[
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.showSingleFormDialog(
                      title: 'Beri Tanggapan',
                      name: 'text',
                      label: 'Tanggapan',
                      hintText: 'Masukkan tanggapan kamu',
                      maxLines: 4,
                      primaryButtonText: 'Submit',
                      onSubmitted: (value) {
                        ref
                            .read(createDiscussionCommentProvider.notifier)
                            .createDiscussionComment(
                              userId: CredentialSaver.user!.id!,
                              discussionId: discussion.id!,
                              text: value['text'],
                            );
                      },
                    ),
                    child: const Text('Beri Tanggapan'),
                  ).fullWidth(),
                  FilledButton(
                    onPressed: () => context.showConfirmDialog(
                      title: 'Masalah Terjawab?',
                      message:
                          'Apakah kamu puas dengan jawaban yang diberikan? Aksi ini akan menutup diskusi kamu!',
                      withCheckbox: true,
                      checkboxLabel: 'Saya puas dengan jawaban yang diberikan.',
                      onPressedPrimaryButton: () {
                        ref
                            .read(editDiscussionProvider.notifier)
                            .editDiscussion(
                              discussionId: discussion.id!,
                              status: 'solved',
                            );
                      },
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

  Widget buildDiscussionSection(DiscussionDetailModel discussion) {
    if (discussion.status == 'open') {
      if (discussion.asker!.id == CredentialSaver.user!.id) {
        return Text(
          'Pertanyaan kamu akan segera dijawab oleh Admin atau Pakar kami.',
          style: textTheme.bodyMedium!.copyWith(
            color: secondaryTextColor,
          ),
        );
      }

      return const SizedBox();
    }

    return Column(
      children: List<Padding>.generate(
        discussion.comments!.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index == discussion.comments!.length - 1 ? 0 : 12,
          ),
          child: DiscussionReplyCard(
            comment: discussion.comments![index],
            asker: discussion.asker!,
          ),
        ),
      ),
    );
  }
}
