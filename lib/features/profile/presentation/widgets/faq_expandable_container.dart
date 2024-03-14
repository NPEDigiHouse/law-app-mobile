// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class FAQExpandableContainer extends StatefulWidget {
  final Map<String, String> item;

  const FAQExpandableContainer({super.key, required this.item});

  @override
  State<FAQExpandableContainer> createState() => _FAQExpandableContainerState();
}

class _FAQExpandableContainerState extends State<FAQExpandableContainer> {
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
                        '${widget.item["question"]}',
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('${widget.item["answer"]}'),
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
                                  textFieldInitialValue:
                                      widget.item["question"],
                                  textAreaInitialValue: widget.item["answer"],
                                  primaryButtonText: 'Edit',
                                  onSubmitted: (value) {},
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
                                onPressedPrimaryButton: () {},
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
