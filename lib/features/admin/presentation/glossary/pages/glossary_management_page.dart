// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/features/admin/presentation/glossary/widgets/glossary_card.dart';
import 'package:law_app/features/glossary/data/models/glossary_model.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';
import 'package:law_app/features/shared/widgets/text_field/search_field.dart';

class GlossaryManagementPage extends ConsumerWidget {
  const GlossaryManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Container(
          color: scaffoldBackgroundColor,
          child: HeaderContainer(
            height: 180,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: secondaryColor,
                      ),
                      child: IconButton(
                        onPressed: () => context.back(),
                        icon: SvgAsset(
                          assetPath: AssetPath.getIcon('caret-line-left.svg'),
                          color: primaryColor,
                          width: 24,
                        ),
                        tooltip: 'Kembali',
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Kelola Glosarium',
                          style: textTheme.titleLarge!.copyWith(
                            color: scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchField(
                  text: query,
                  hintText: 'Cari kosa kata',
                  onChanged: searchGlossaries,
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        itemBuilder: (context, index) {
          return GlossaryCard(
            glossary: GlossaryModel(
              title: 'Glossary Item ${index + 1}',
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: 30,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        backgroundColor: primaryColor,
        tooltip: 'Tambah Kosa Kata',
        onPressed: () => context.showSingleFormTextAreaDialog(
          title: 'Tambah Kosa Kata',
          textFieldName: 'Kata/Istilah',
          textFieldLabel: 'title',
          textFieldHint: 'Masukkan kata/istilah',
          textAreaName: 'description',
          textAreaLabel: 'Pengertian/Deskripsi',
          textAreaHint: 'Masukkan pengertian/deskripsi dari kosa kata',
          primaryButtonText: 'Tambah',
        ),
        child: SvgAsset(
          assetPath: AssetPath.getIcon('plus-line.svg'),
          color: scaffoldBackgroundColor,
          width: 24,
        ),
      ),
    );
  }

  void searchGlossaries(String query) {
    // ref.read(queryProvider.notifier).state = query;

    // if (query.isNotEmpty) {
    //   EasyDebounce.debounce(
    //     'search-debouncer',
    //     const Duration(milliseconds: 800),
    //     () => ref.read(getUsersProvider.notifier).searchUsers(query: query),
    //   );
    // } else {
    //   ref.invalidate(getUsersProvider);
    // }
  }
}
