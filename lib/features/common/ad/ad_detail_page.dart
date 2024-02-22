// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class AdDetailPage extends StatelessWidget {
  const AdDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Notifikasi',
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 130),
            SizedBox(
              height: 240,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      AssetPath.getImage('sample_carousel_image1.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(0, 228, 77, 66),
                            Color.fromARGB(150, 244, 133, 125),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Dapatkan Promo Menarik, Pertanyaan Khusus Unlimited!',
                    style: textTheme.titleLarge!.copyWith(
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem.\n\nNam semper vehicula ex, ac fermentum orci elementum ac.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem.',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
