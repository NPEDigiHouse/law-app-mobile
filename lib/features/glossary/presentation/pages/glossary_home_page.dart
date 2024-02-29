// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/glossary/presentation/pages/glossary_detail_page.dart';
import 'package:law_app/features/glossary/presentation/providers/glossary_search_history_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class GlossaryHomePage extends ConsumerWidget {
  const GlossaryHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistory = ref.watch(glossarySearchHistoryProvider);

    ref.listen(glossarySearchHistoryProvider, (_, state) {
      state.when(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(glossarySearchHistoryProvider);
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
      body: searchHistory.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          if (data == null) return null;

          if (data.isEmpty) {
            return const CustomInformation(
              illustrationName: 'house-searching-cuate.svg',
              title: 'Riwayat pencarian kosong',
              subtitle: 'Riwayat pencarian glosarium masih kosong.',
            );
          }

          return CustomScrollView(
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
                              'Anda yakin ingin menghapus semua riwayat pencarian?',
                          primaryButtonText: 'Hapus',
                          onPressedPrimaryButton: () {
                            ref
                                .read(glossarySearchHistoryProvider.notifier)
                                .deleteAllGlossariesSearchHistory();

                            navigatorKey.currentState!.pop();
                          },
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
                    final glossary = data[index].glosarium;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      title: Text(
                        '${glossary?.title}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      titleTextStyle: textTheme.bodyLarge,
                      trailing: GestureDetector(
                        onTap: () {
                          ref
                              .read(glossarySearchHistoryProvider.notifier)
                              .deleteGlossarySearchHistory(id: data[index].id!);
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                        ),
                      ),
                      onTap: () => navigatorKey.currentState!.pushNamed(
                        glossaryDetailRoute,
                        arguments: GlossaryDetailPageArgs(id: glossary!.id!),
                      ),
                      visualDensity: const VisualDensity(
                        vertical: VisualDensity.minimumDensity,
                      ),
                    );
                  },
                  childCount: data.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
