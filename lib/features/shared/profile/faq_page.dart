import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/custom_app_bar.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    List faqItems = [
      {
        "question": "Question 1",
        "answer":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
      },
      {
        "question": "Question 2",
        "answer":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
      },
      {
        "question": "Question 3",
        "answer":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
      },
      {
        "question": "Question 4",
        "answer":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
      },
      {
        "question": "Question 5",
        "answer":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac.",
      },
    ];
    return Scaffold(
      appBar: const CustomAppBar(
        title: "FAQ",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Frequently Asked Question",
                style: textTheme.headlineMedium!.copyWith(
                  color: primaryColor,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: secondaryTextColor,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: faqItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: FAQContainer(faqItem: faqItems[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQContainer extends StatefulWidget {
  const FAQContainer({
    super.key,
    required this.faqItem,
  });

  final Map faqItem;

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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  isCollapse.value = !isCollapse.value;
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.faqItem["question"],
                        style: textTheme.headlineSmall!.copyWith(
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: ((!isCollapse.value) ? -22.5 : 22.5) * math.pi,
                      child: SvgAsset(
                        width: 20,
                        height: 20,
                        assetPath: AssetPath.getIcon("caret-line-left.svg"),
                      ),
                    ),
                  ],
                ),
              ),
              if (value)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.faqItem["answer"],
                    style: textTheme.bodyMedium!.copyWith(
                      color: primaryTextColor,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
