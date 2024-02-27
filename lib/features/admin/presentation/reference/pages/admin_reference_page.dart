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

class AdminReferencePage extends StatelessWidget {
  const AdminReferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        "icon": "grid-view-solid.svg",
        "text": "Kelola Kategori Pertanyaan",
        "onTap": () {
          navigatorKey.currentState!
              .pushNamed(adminManageQuestionCategoryRoute);
        },
      },
      {
        "icon": "question-circle-fill.svg",
        "text": "Kelola Frequently Asked Questions (FAQ)",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(faqRoute, arguments: true);
        },
      },
      {
        "icon": "phone-handset-solid.svg",
        "text": "Kelola Kontak Kami",
        "onTap": () {
          navigatorKey.currentState!.pushNamed(contactUsRoute, arguments: true);
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return InkWellContainer(
              radius: 12,
              color: secondaryColor,
              onTap: items[index]["onTap"],
              margin: EdgeInsets.only(
                bottom: index == items.length ? 0 : 12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  GradientBackgroundIcon(
                    icon: items[index]["icon"],
                    padding: 12,
                    size: 64,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      items[index]["text"],
                      maxLines: 3,
                      style: textTheme.titleLarge!.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
