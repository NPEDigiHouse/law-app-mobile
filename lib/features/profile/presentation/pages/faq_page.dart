// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    const faqItems = [
      {
        "question": "Question 1",
        "answer":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
      },
      {
        "question": "Question 2",
        "answer":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. ",
      },
      {
        "question": "Question 3",
        "answer":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex.",
      },
      {
        "question": "Question 4",
        "answer":
            "Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
      },
      {
        "question": "Question 5",
        "answer":
            "Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex.",
      },
    ];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'FAQ',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                itemCount: faqItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                    ),
                    child: FAQContainer(faqItem: faqItems[index]),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQContainer extends StatefulWidget {
  final Map<String, String> faqItem;

  const FAQContainer({super.key, required this.faqItem});

  @override
  State<FAQContainer> createState() => _FAQContainerState();
}

class _FAQContainerState extends State<FAQContainer> {
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
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              InkWell(
                onTap: () => isCollapse.value = !value,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.faqItem["question"]!,
                        style: textTheme.headlineSmall!.copyWith(
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    SvgAsset(
                      assetPath: AssetPath.getIcon(
                        value ? "caret-line-up.svg" : "caret-line-down.svg",
                      ),
                      width: 20,
                    ),
                  ],
                ),
              ),
              if (value)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(widget.faqItem["answer"]!),
                ),
            ],
          ),
        );
      },
    );
  }
}
