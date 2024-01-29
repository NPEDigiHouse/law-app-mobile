import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/search_field.dart';

class GlossaryHomePage extends StatelessWidget {
  const GlossaryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: HeaderContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Glosarium',
                style: textTheme.headlineMedium!.copyWith(
                  color: accentTextColor,
                ),
              ),
              Text(
                'Cari definisi dari berbagai istilah hukum untuk memperkaya referensi dan pengetahuanmu!',
                style: textTheme.bodySmall!.copyWith(
                  color: scaffoldBackgroundColor,
                ),
              ),
              const SizedBox(height: 12),
              SearchField(
                text: '',
                hintText: 'Cari kosa kata...',
                readOnly: true,
                canRequestFocus: false,
                textInputAction: TextInputAction.none,
                onTap: () => navigatorKey.currentState!.pushNamed(
                  glossarySearchRoute,
                ),
              ),
            ],
          ),
        ),
      ),
      body: const CustomInformation(
        illustrationName: 'house-searching-cuate.svg',
        title: 'Riwayat Pencarian',
        subtitle: 'Riwayat pencarian Anda akan muncul di sini',
      ),
    );
  }
}
