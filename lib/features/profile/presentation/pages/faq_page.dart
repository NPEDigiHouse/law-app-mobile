// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/enums/banner_type.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/presentation/reference/providers/faq_provider.dart';
import 'package:law_app/features/profile/presentation/widgets/faq_expandable_container.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class FAQPage extends ConsumerWidget {
  final bool isAdmin;

  const FAQPage({super.key, this.isAdmin = false});

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
            });
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: isAdmin ? 'Kelola FAQ' : 'FAQ',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Frequently Asked Question",
                style: textTheme.headlineMedium!.copyWith(
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              faqs.maybeWhen(
                loading: () => const LoadingIndicator(),
                data: (faqs) {
                  if (faqs == null) return Container();

                  if (faqs.isEmpty) {
                    return const CustomInformation(
                      illustrationName: 'house-searching-cuate.svg',
                      title: 'Belum ada data',
                    );
                  }

                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: faqs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: FAQExpandableContainer(
                          item: faqs[index],
                          isAdmin: isAdmin,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(color: secondaryTextColor);
                    },
                  );
                },
                orElse: () {
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isAdmin
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

                    ref.read(faqProvider.notifier).createFaq(
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
