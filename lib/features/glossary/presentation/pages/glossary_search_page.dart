import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/glossary/presentation/widgets/search_empty_text.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/text_field/search_field.dart';

class GlossarySearchPage extends StatefulWidget {
  const GlossarySearchPage({super.key});

  @override
  State<GlossarySearchPage> createState() => _GlossarySearchPageState();
}

class _GlossarySearchPageState extends State<GlossarySearchPage> {
  late final ValueNotifier<String> query;
  late List<Glossary> glossaries;

  @override
  void initState() {
    super.initState();

    query = ValueNotifier('');
    glossaries = dummyGlossaries;
  }

  @override
  void dispose() {
    super.dispose();

    query.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              ValueListenableBuilder(
                valueListenable: query,
                builder: (context, query, child) {
                  return SearchField(
                    text: query,
                    hintText: 'Cari kosa kata',
                    autoFocus: true,
                    onChanged: searchTerm,
                    onFocusChanged: (value) {
                      if (!value && query.isEmpty) {
                        navigatorKey.currentState!.pop();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (query.value.isEmpty) {
            return const SearchEmptyText(
              title: 'Hasil Pencarian',
              subtitle: 'Hasil pencarian Anda akan muncul di sini.',
            );
          }

          if (glossaries.isEmpty) {
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
                  glossaries[index].term,
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
                  arguments: glossaries[index],
                ),
                visualDensity: const VisualDensity(
                  vertical: VisualDensity.minimumDensity,
                ),
              );
            },
            itemCount: glossaries.length,
          );
        },
      ),
    );
  }

  void searchTerm(String query) {
    this.query.value = query;

    EasyDebounce.debounce(
      'search-debouncer',
      const Duration(milliseconds: 800),
      () {
        final result = dummyGlossaries.where((glossary) {
          final queryLower = query.toLowerCase();
          final termLower = glossary.term.toLowerCase();

          return termLower.contains(queryLower);
        }).toList();

        setState(() => glossaries = result);
      },
    );

    if (query.isEmpty) {
      EasyDebounce.fire('search-debouncer');
    }
  }
}
