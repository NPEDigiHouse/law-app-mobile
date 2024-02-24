// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/glossary/presentation/widgets/search_empty_text.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/text_field/search_field.dart';

class GlossarySearchPage extends ConsumerWidget {
  const GlossarySearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);

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
                onChanged: (query) => searchTerm(ref, query),
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
      body: Builder(
        builder: (context) {
          if (query.isEmpty) {
            return const SearchEmptyText(
              title: 'Hasil Pencarian',
              subtitle: 'Hasil pencarian kamu akan muncul di sini.',
            );
          }

          if (dummyGlossaries.isEmpty) {
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
                  dummyGlossaries[index].term,
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
                  arguments: dummyGlossaries[index],
                ),
                visualDensity: const VisualDensity(
                  vertical: VisualDensity.minimumDensity,
                ),
              );
            },
            itemCount: dummyGlossaries.length,
          );
        },
      ),
    );
  }

  void searchTerm(WidgetRef ref, String query) {
    ref.read(queryProvider.notifier).state = query;

    EasyDebounce.debounce(
      'search-debouncer',
      const Duration(milliseconds: 800),
      () {
        // final result = dummyGlossaries.where((glossary) {
        //   final queryLower = query.toLowerCase();
        //   final termLower = glossary.term.toLowerCase();

        //   return termLower.contains(queryLower);
        // }).toList();

        // setState(() => glossaries = result);
      },
    );

    if (query.isEmpty) {
      EasyDebounce.fire('search-debouncer');
    }
  }
}
