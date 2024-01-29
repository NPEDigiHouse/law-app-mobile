import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/custom_app_bar.dart';
import 'package:law_app/features/shared/widgets/icon_with_gradient_background.dart';

class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    List certificateItems = [
      {
        "img": "certificate.jpg",
        "text": "Tips Menerjemahkan Dokumen Hukum Berbahasa Asing"
      },
      {"img": "certificate.jpg", "text": "Tips Belajar Hukum"},
      {
        "img": "certificate.jpg",
        "text": "Tips Menerjemahkan Dokumen Hukum Berbahasa Asing"
      },
      {"img": "certificate.jpg", "text": "Tips Belajar Hukum"},
      {
        "img": "certificate.jpg",
        "text": "Tips Menerjemahkan Dokumen Hukum Berbahasa Asing"
      },
      {"img": "certificate.jpg", "text": "Tips Belajar Hukum"},
      {
        "img": "certificate.jpg",
        "text": "Tips Menerjemahkan Dokumen Hukum Berbahasa Asing"
      },
      {"img": "certificate.jpg", "text": "Tips Belajar Hukum"},
    ];
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Sertifikat",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sertifikat",
                style: textTheme.headlineMedium!.copyWith(
                  color: primaryColor,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: certificateItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 4.0,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const IconWithGradientBackground(
                            icon: "certificate-solid.svg",
                            size: 72,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              certificateItems[index]["text"],
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
