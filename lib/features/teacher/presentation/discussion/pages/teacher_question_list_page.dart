// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class TeacherQuestionListPage extends ConsumerStatefulWidget {
  const TeacherQuestionListPage({super.key});

  @override
  ConsumerState<TeacherQuestionListPage> createState() =>
      _TeacherQuestionListPageState();
}

class _TeacherQuestionListPageState
    extends ConsumerState<TeacherQuestionListPage> {
  late final ValueNotifier<String> query;
  late List<Question> questions;

  @override
  void initState() {
    super.initState();

    query = ValueNotifier('');
    questions = dummyQuestions;
  }

  @override
  void dispose() {
    super.dispose();

    query.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    final items = isSearching ? questions : dummyQuestions;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        return FunctionHelper.handleSearchingOnPop(ref, didPop, isSearching);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 124 : 96),
          child: buildHeaderContainer(isSearching),
        ),
        body: Builder(
          builder: (context) {
            if (isSearching && questions.isEmpty) {
              return const CustomInformation(
                illustrationName: 'discussion-cuate.svg',
                title: 'Pertanyaan tidak ditemukan',
                subtitle: 'Judul pertanyaan tersebut tidak ditemukan.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 20,
              ),
              itemBuilder: (context, index) {
                return DiscussionCard(
                  question: items[index],
                  role: 'teacher',
                  isDetail: true,
                  withProfile: true,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
              itemCount: items.length,
            );
          },
        ),
      ),
    );
  }

  HeaderContainer buildHeaderContainer(bool isSearching) {
    if (isSearching) {
      return HeaderContainer(
        child: Column(
          children: [
            Text(
              'Cari Pertanyaan',
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
                  hintText: 'Cari judul pertanyaan',
                  autoFocus: true,
                  onChanged: searchQuestion,
                  onFocusChange: (isFocus) {
                    if (!isFocus && query.isEmpty) {
                      ref.read(isSearchingProvider.notifier).state = false;
                    }
                  },
                );
              },
            ),
          ],
        ),
      );
    }

    return HeaderContainer(
      title: 'Perlu Dijawab',
      withBackButton: true,
      withTrailingButton: true,
      trailingButtonIconName: 'search-line.svg',
      trailingButtonTooltip: 'Cari',
      onPressedTrailingButton: () {
        ref.read(isSearchingProvider.notifier).state = true;
      },
    );
  }

  void searchQuestion(String query) {
    this.query.value = query;

    EasyDebounce.debounce(
      'search-debouncer',
      const Duration(milliseconds: 800),
      () {
        final result = dummyQuestions.where((question) {
          final queryLower = query.toLowerCase();
          final titleLower = question.title.toLowerCase();

          return titleLower.contains(queryLower);
        }).toList();

        setState(() => questions = result);
      },
    );

    if (query.isEmpty) {
      EasyDebounce.fire('search-debouncer');
    }
  }
}
