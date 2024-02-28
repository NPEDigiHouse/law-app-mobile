// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/profile/presentation/widgets/faq_expandable_container.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class FAQPage extends StatelessWidget {
  final bool isAdmin;

  const FAQPage({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    const items = [
      {
        "question": "Question 1",
        "answer":
            "Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
      },
      {
        "question": "Question 2",
        "answer":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. ",
      },
      {
        "question": "Question 3",
        "answer":
            "Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex.",
      },
    ];

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
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: FAQExpandableContainer(
                      item: items[index],
                      isAdmin: isAdmin,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(color: secondaryTextColor);
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
                  onSubmitted: (value) {},
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
