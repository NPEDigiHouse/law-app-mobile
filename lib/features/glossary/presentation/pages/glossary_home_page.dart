import 'package:flutter/material.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/text_field/search_field.dart';

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
                hintText: 'Cari kosa kata',
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Riwayat Pencarian',
                      style: textTheme.titleLarge,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.showConfirmDialog(
                      title: 'Konfirmasi',
                      message:
                          'Anda yakin ingin menghapus seluruh riwayat pencarian?',
                      onPressedPrimaryButton: () {},
                    ),
                    child: Text(
                      'Hapus Semua',
                      style: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  title: Text(
                    dummyGlossaries[index].term,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  titleTextStyle: textTheme.bodyLarge,
                  trailing: const Icon(
                    Icons.close_rounded,
                    size: 16,
                  ),
                  onTap: () => navigatorKey.currentState!.pushNamed(
                    glossaryDetailRoute,
                    arguments: dummyGlossaries[index],
                  ),
                  visualDensity: const VisualDensity(
                    vertical: VisualDensity.minimumDensity,
                  ),
                );
              },
              childCount: dummyGlossaries.length,
            ),
          ),
        ],
      ),
    );
  }
}
