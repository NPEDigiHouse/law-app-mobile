import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/glossary/presentation/widgets/search_empty_text.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/search_field.dart';

class GlossarySearchPage extends StatefulWidget {
  const GlossarySearchPage({super.key});

  @override
  State<GlossarySearchPage> createState() => _GlossarySearchPageState();
}

class _GlossarySearchPageState extends State<GlossarySearchPage> {
  late final ValueNotifier<String> query;
  late List<Glossary> glossaryList;

  @override
  void initState() {
    super.initState();

    query = ValueNotifier('');
    glossaryList = glossaries;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Cari Kata',
                  style: textTheme.titleMedium!.copyWith(
                    color: scaffoldBackgroundColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: query,
                builder: (context, query, child) {
                  return SearchField(
                    text: query,
                    hintText: 'Cari kosa kata...',
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

          if (glossaryList.isEmpty) {
            return const SearchEmptyText(
              title: 'Hasil Tidak Ditemukan',
              subtitle: 'Tidak ada istilah yang cocok untuk kata tersebut.',
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  glossaryList[index].term,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                titleTextStyle: textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                trailing: const Icon(
                  Icons.north_west_rounded,
                  size: 20,
                ),
                onTap: () => navigatorKey.currentState!.pushNamed(
                  glossaryDetailRoute,
                  arguments: glossaryList[index],
                ),
              );
            },
            itemCount: glossaryList.length,
          );
        },
      ),
    );
  }

  void searchTerm(String query) {
    this.query.value = query;

    EasyDebounce.debounce(
      'search-debouncer',
      const Duration(milliseconds: 750),
      () {
        final result = glossaries.where((glossary) {
          final valueLower = query.toLowerCase();
          final termLower = glossary.term.toLowerCase();

          return termLower.contains(valueLower);
        }).toList();

        setState(() => glossaryList = result);
      },
    );

    if (query.isEmpty) {
      EasyDebounce.fire('search-debouncer');
    }
  }
}
