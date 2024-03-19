// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/shared/widgets/gradient_background_icon.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/ink_well_container.dart';

class ReferencePage extends StatelessWidget {
  const ReferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        "icon": "grid-view-solid.svg",
        "text": "Kelola Kategori Diskusi",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(discussionCategoryRoute);
        },
      },
      {
        "icon": "question-circle-fill.svg",
        "text": "Kelola Frequently Asked Questions (FAQ)",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(faqRoute);
        },
      },
      {
        "icon": "phone-handset-solid.svg",
        "text": "Kelola Kontak Kami",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(contactUsRoute);
        },
      },
    ];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Referensi',
          withBackButton: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return InkWellContainer(
              radius: 12,
              color: secondaryColor,
              onTap: items[index]["onTap"],
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  GradientBackgroundIcon(
                    icon: items[index]["icon"],
                    padding: 12,
                    size: 56,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      items[index]["text"],
                      style: textTheme.titleMedium!.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ),
    );
  }
}
