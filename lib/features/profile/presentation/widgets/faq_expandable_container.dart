// ignore_for_file: public_member_api_docs, sort_constructors_first
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/faq_models/faq_model.dart';
import 'package:law_app/features/admin/presentation/reference/providers/faq_provider.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class FAQExpandableContainer extends ConsumerStatefulWidget {
  final FaqModel item;
  final bool isAdmin;

  const FAQExpandableContainer({
    super.key,
    required this.item,
    required this.isAdmin,
  });

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
            children: [
              InkWellContainer(
                radius: 8,
                onTap: () => this.isCollapse.value = !isCollapse,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.item.question}',
                        style: textTheme.titleLarge!.copyWith(
                          color: primaryTextColor,
                        ),
                      ),
                    ),
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
              if (isCollapse)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${widget.item.answer}',
                        textAlign: TextAlign.left,
                      ),
                    ),
                    if (CredentialSaver.user!.role! == 'admin') ...[
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
                                  textAreaName: "answer",
                                  textAreaLabel: "Jawaban",
                                  textAreaHint:
                                      "Masukkan jawaban dari pertanyaan",
                                  textFieldInitialValue: widget.item.question,
                                  textAreaInitialValue: widget.item.answer,
                                  primaryButtonText: 'Edit',
                                  onSubmitted: (value) {
                                    final newFaq = widget.item.copyWith(
                                        question: value['question'],
                                        answer: value['answer']);
                                    ref
                                        .read(faqProvider.notifier)
                                        .editFaq(faq: newFaq);

                                    navigatorKey.currentState!.pop();
                                  },
                                );
                              },
                              icon: SvgAsset(
                                assetPath: AssetPath.getIcon(
                                  'pencil-solid.svg',
                                ),
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
                                message:
                                    "Apakah Anda yakin ingin menghapus pertanyaan ini?",
                                primaryButtonText: 'Hapus',
                                onPressedPrimaryButton: () {
                                  navigatorKey.currentState!.pop();
                                  ref
                                      .read(faqProvider.notifier)
                                      .deleteFaq(id: widget.item.id!);
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
                ),
            ],
          ),
        );
      },
    );
  }
}
