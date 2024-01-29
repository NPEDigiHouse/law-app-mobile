import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/gradient_background_icon.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final certificateItems = [
      {
        "img": "certificate.jpg",
        "text": "Tips Menerjemahkan Dokumen Hukum Berbahasa Asing",
      },
      {
        "img": "certificate.jpg",
        "text": "Tips Belajar Hukum",
      },
      {
        "img": "certificate.jpg",
        "text": "Tips Menerjemahkan Dokumen Hukum Berbahasa Asing",
      },
      {
        "img": "certificate.jpg",
        "text": "Tips Belajar Hukum",
      },
      {
        "img": "certificate.jpg",
        "text": "Tips Menerjemahkan Dokumen Hukum Berbahasa Asing",
      },
    ];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          withBackButton: true,
          title: 'Sertifikat',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sertifikat",
                style: textTheme.headlineMedium!.copyWith(
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: certificateItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const GradientBackgroundIcon(
                            icon: "certificate-solid.svg",
                            size: 72,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              certificateItems[index]["text"]!,
                              maxLines: 3,
                              style: textTheme.bodyLarge!.copyWith(
                                color: primaryTextColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
