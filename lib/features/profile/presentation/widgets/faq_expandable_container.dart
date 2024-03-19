// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/reference_models/faq_model.dart';
import 'package:law_app/features/admin/presentation/reference/providers/faq_provider.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class FAQExpandableContainer extends ConsumerStatefulWidget {
  final FAQModel faq;

  const FAQExpandableContainer({super.key, required this.faq});

  @override
  ConsumerState<FAQExpandableContainer> createState() =>
      _FAQExpandableContainerState();
}

class _FAQExpandableContainerState
    extends ConsumerState<FAQExpandableContainer> {
  late final ValueNotifier<bool> isCollapse;

  @override
  void initState() {
    super.initState();

    isCollapse = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isCollapse.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isCollapse,
      builder: (context, isCollapse, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWellContainer(
                radius: 8,
                onTap: () => this.isCollapse.value = !isCollapse,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.faq.question}',
                        style: textTheme.titleLarge!.copyWith(
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgAsset(
                      assetPath: AssetPath.getIcon(
                        isCollapse
                            ? "caret-line-up.svg"
                            : "caret-line-down.svg",
                      ),
                      width: 20,
                    ),
                  ],
                ),
              ),
              if (isCollapse) ...[
                const SizedBox(height: 8),
                Text('${widget.faq.answer}'),
                if (CredentialSaver.user!.role == 'admin') ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: infoColor,
                        ),
                        child: IconButton(
                          onPressed: () {
                            context.showSingleFormTextAreaDialog(
                              title: "Edit FAQ",
                              textFieldName: "question",
                              textFieldLabel: "Pertanyaan",
                              textFieldHint: "Masukkan pertanyaan",
                              textFieldInitialValue: widget.faq.question,
                              textAreaName: "answer",
                              textAreaLabel: "Jawaban",
                              textAreaHint: "Masukkan jawaban dari pertanyaan",
                              textAreaInitialValue: widget.faq.answer,
                              primaryButtonText: 'Edit',
                              onSubmitted: (value) {
                                navigatorKey.currentState!.pop();

                                ref.read(faqProvider.notifier).editFAQ(
                                      faq: widget.faq.copyWith(
                                        question: value['question'],
                                        answer: value['answer'],
                                      ),
                                    );
                              },
                            );
                          },
                          icon: SvgAsset(
                            assetPath: AssetPath.getIcon('pencil-solid.svg'),
                            color: scaffoldBackgroundColor,
                            width: 24,
                          ),
                          tooltip: 'Edit',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: errorColor,
                        ),
                        child: IconButton(
                          onPressed: () => context.showConfirmDialog(
                            title: "Hapus FAQ?",
                            message: "Anda yakin ingin menghapus FAQ ini?",
                            primaryButtonText: 'Hapus',
                            onPressedPrimaryButton: () {
                              navigatorKey.currentState!.pop();

                              ref
                                  .read(faqProvider.notifier)
                                  .deleteFAQ(id: widget.faq.id!);
                            },
                          ),
                          icon: SvgAsset(
                            assetPath: AssetPath.getIcon('trash-solid.svg'),
                            color: scaffoldBackgroundColor,
                            width: 24,
                          ),
                          tooltip: 'Hapus',
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
