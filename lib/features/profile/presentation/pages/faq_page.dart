// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/reference/providers/faq_provider.dart';
import 'package:law_app/features/profile/presentation/widgets/faq_expandable_container.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class FAQPage extends ConsumerWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqs = ref.watch(faqProvider);

    ref.listen(faqProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(faqProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'FAQ',
          withBackButton: true,
        ),
      ),
      body: faqs.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (faqs) {
          if (faqs == null) return null;

          if (faqs.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'FAQ masih kosong',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Text(
                  'Frequently Asked Questions',
                  style: textTheme.headlineMedium!.copyWith(
                    color: primaryColor,
                    height: 0,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: FAQExpandableContainer(faq: faqs[index]),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(color: secondaryTextColor);
                  },
                  itemCount: faqs.length,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: CredentialSaver.user!.role == 'admin'
          ? Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: GradientColors.redPastel,
                ),
              ),
              child: IconButton(
                onPressed: () => context.showSingleFormTextAreaDialog(
                  title: "Tambah FAQ",
                  textFieldName: "question",
                  textFieldLabel: "Pertanyaan",
                  textFieldHint: "Masukkan pertanyaan",
                  textAreaName: "answer",
                  textAreaLabel: "Jawaban",
                  textAreaHint: "Masukkan jawaban dari pertanyaan",
                  primaryButtonText: 'Tambah',
                  onSubmitted: (value) {
                    navigatorKey.currentState!.pop();

                    ref.read(faqProvider.notifier).createFAQ(
                          question: value['question'],
                          answer: value['answer'],
                        );
                  },
                ),
                icon: SvgAsset(
                  assetPath: AssetPath.getIcon('plus-line.svg'),
                  color: scaffoldBackgroundColor,
                  width: 24,
                ),
                tooltip: 'Tambah',
              ),
            )
          : null,
    );
  }
}
