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
import 'package:law_app/features/glossary/presentation/providers/search_glossary_provider.dart';
import 'package:law_app/features/glossary/presentation/widgets/search_empty_text.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';
import 'package:law_app/features/shared/widgets/text_field/search_field.dart';

class GlossarySearchPage extends ConsumerWidget {
  const GlossarySearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);
    final glossaries = ref.watch(searchGlossaryProvider);

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
          if (query.isEmpty || data == null) {
            return const SearchEmptyText(
              title: 'Hasil Pencarian',
              subtitle: 'Hasil pencarian kamu akan muncul di sini.',
            );
          }

          if (data.isEmpty) {
            return const SearchEmptyText(
              title: 'Hasil Tidak Ditemukan',
              subtitle: 'Tidak ada istilah yang cocok untuk kata tersebut.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  '${data[index].title}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                titleTextStyle: textTheme.bodyLarge,
                trailing: const Icon(
                  Icons.north_west_rounded,
                  size: 16,
                ),
                onTap: () => navigatorKey.currentState!.pushNamed(
                  glossaryDetailRoute,
                  arguments: GlossaryDetailPageArgs(
                    id: data[index].id!,
                  ),
                ),
                visualDensity: const VisualDensity(
                  vertical: VisualDensity.minimumDensity,
                ),
              );
            },
            itemCount: data.length,
          );
        },
      ),
    );
  }

  void searchGlossaries(WidgetRef ref, String query) {
    ref.read(queryProvider.notifier).state = query;

    if (query.isNotEmpty) {
      EasyDebounce.debounce(
        'search-debouncer',
        const Duration(milliseconds: 800),
        () => ref
            .read(searchGlossaryProvider.notifier)
            .searchGlossary(query: query),
      );
    } else {
      ref.invalidate(searchGlossaryProvider);
    }
  }
}
