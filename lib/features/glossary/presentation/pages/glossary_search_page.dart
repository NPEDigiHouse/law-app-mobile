// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';
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
import 'package:law_app/features/glossary/presentation/providers/search_glossary_provider.dart';
import 'package:law_app/features/glossary/presentation/widgets/search_empty_text.dart';
import 'package:law_app/features/shared/providers/offset_provider.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class GlossarySearchPage extends ConsumerWidget {
  const GlossarySearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);
    final glossaries = ref.watch(searchGlossaryProvider);
    final offset = ref.watch(offsetProvider);

    if (query.isNotEmpty) {
      ref.listen(searchGlossaryProvider, (_, state) {
        state.when(
          error: (error, _) {
            if ('$error' == kNoInternetConnection) {
              context.showNetworkErrorModalBottomSheet(
                onPressedPrimaryButton: () {
                  navigatorKey.currentState!.pop();
                  ref
                      .read(searchGlossaryProvider.notifier)
                      .searchGlossary(query: query);
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
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(124),
        child: HeaderContainer(
          child: Column(
            children: [
              Text(
                'Cari Kata',
                style: textTheme.titleMedium!.copyWith(
                  color: scaffoldBackgroundColor,
                ),
              ),
              const SizedBox(height: 10),
              SearchField(
                text: query,
                hintText: 'Cari kosa kata',
                autoFocus: true,
                onChanged: (query) => searchGlossaries(ref, query),
                onFocusChange: (isFocus) {
                  if (!isFocus && query.isEmpty) {
                    navigatorKey.currentState!.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: glossaries.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (data) {
          if (data == null || query.isEmpty) {
            return const SearchEmptyText(
              title: 'Hasil Pencarian',
              subtitle: 'Hasil pencarian kamu akan muncul di sini.',
            );
          }

          final glossaries = data.glossaries;
          final hasMore = data.hasMore;

          if (glossaries.isEmpty) {
            return const SearchEmptyText(
              title: 'Hasil Tidak Ditemukan',
              subtitle: 'Tidak ada istilah yang cocok untuk kata tersebut.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              if (index >= glossaries.length) {
                return buildFetchMoreButton(ref, query, offset);
              }

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  '${glossaries[index].title}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                titleTextStyle: textTheme.bodyLarge,
                trailing: const Icon(
                  Icons.north_west_rounded,
                  size: 16,
                ),
                onTap: () {
                  if (!ref
                      .read(glossarySearchHistoryProvider.notifier)
                      .isGlossaryAlreadyExist(glossaries[index])) {
                    ref
                        .read(glossarySearchHistoryProvider.notifier)
                        .createGlossarySearchHistory(id: glossaries[index].id!);
                  }

                  navigatorKey.currentState!.pushNamed(
                    glossaryDetailRoute,
                    arguments: GlossaryDetailPageArgs(
                      id: glossaries[index].id!,
                    ),
                  );
                },
                visualDensity: const VisualDensity(
                  vertical: VisualDensity.minimumDensity,
                ),
              );
            },
            itemCount: hasMore ? glossaries.length + 1 : glossaries.length,
          );
        },
      ),
    );
  }

  Padding buildFetchMoreButton(WidgetRef ref, String query, int offset) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: () {
          ref
              .read(searchGlossaryProvider.notifier)
              .fetchMoreGlossary(query: query, offset: offset);
          ref.read(offsetProvider.notifier).state = offset + 10;
        },
        child: const Text('Lihat hasil lainnya'),
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
          ref
              .read(searchGlossaryProvider.notifier)
              .searchGlossary(query: query);
          ref.invalidate(offsetProvider);
        },
      );
    } else {
      ref.invalidate(searchGlossaryProvider);
    }
  }
}
