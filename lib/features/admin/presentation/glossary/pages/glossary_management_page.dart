// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/glossary_models/glossary_post_model.dart';
import 'package:law_app/features/admin/presentation/glossary/widgets/glossary_card.dart';
import 'package:law_app/features/glossary/presentation/providers/glossary_provider.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class GlossaryManagementPage extends ConsumerWidget {
  const GlossaryManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);
    final glossaries = ref.watch(glossaryProvider);

    ref.listen(glossaryProvider, (_, state) {
      state.when(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(glossaryProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () {},
        data: (_) {},
      );
    });

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
                    const SizedBox(
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SearchField(
                  text: query,
                  hintText: 'Cari kosa kata',
                  onChanged: (query) => searchGlossaries(ref, query),
                ),
              ],
            ),
          ),
        ),
      ),
      body: glossaries.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (glossaries) {
          if (glossaries == null) return null;

          if (glossaries.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Belum ada data',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            itemBuilder: (context, index) {
              return GlossaryCard(
                glossary: glossaries[index],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: glossaries.length,
          );
        },
      ),
      floatingActionButton: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: GradientColors.redPastel,
          ),
        ),
        child: IconButton(
          onPressed: () => context.showSingleFormTextAreaDialog(
            title: 'Tambah Kosa Kata',
            textFieldName: 'title',
            textFieldLabel: 'Kata/Istilah',
            textFieldHint: 'Masukkan kata/istilah',
            textAreaName: 'description',
            textAreaLabel: 'Pengertian/Deskripsi',
            textAreaHint: 'Masukkan pengertian/deskripsi',
            primaryButtonText: 'Tambah',
            onSubmitted: (value) {
              final glossaryPost = GlossaryPostModel(
                title: value['title'],
                description: value['description'],
              );

              ref
                  .read(glossaryProvider.notifier)
                  .createGlossary(glossary: glossaryPost);

              navigatorKey.currentState!.pop();
            },
          ),
          icon: SvgAsset(
            assetPath: AssetPath.getIcon('plus-line.svg'),
            color: scaffoldBackgroundColor,
            width: 24,
          ),
          tooltip: 'Tambah',
        ),
      ),
    );
  }

  void searchGlossaries(WidgetRef ref, String query) {
    ref.read(queryProvider.notifier).state = query;

    if (query.isNotEmpty) {
      EasyDebounce.debounce(
        'search-debouncer',
        const Duration(milliseconds: 800),
        () {
          ref.read(glossaryProvider.notifier).searchGlossaries(query: query);
        },
      );
    } else {
      ref.invalidate(glossaryProvider);
    }
  }
}
