// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/question_status.dart';
import 'package:law_app/core/helpers/function_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/pages/question_list_page.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';
import 'package:law_app/features/shared/widgets/form_field/search_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class TeacherQuestionHistoryPage extends ConsumerStatefulWidget {
  const TeacherQuestionHistoryPage({super.key});

  @override
  ConsumerState<TeacherQuestionHistoryPage> createState() =>
      _TeacherQuestionHistoryPageState();
}

class _TeacherQuestionHistoryPageState
    extends ConsumerState<TeacherQuestionHistoryPage> {
  late final PageController pageController;
  late final ValueNotifier<QuestionStatus> selectedStatus;
  late final ValueNotifier<String> query;
  late List<Question> questions;

  @override
  void initState() {
    super.initState();

    pageController = PageController();
    selectedStatus = ValueNotifier(QuestionStatus.discuss);
    query = ValueNotifier('');
    questions = dummyQuestions;
  }

  @override
  void dispose() {
    super.dispose();

    pageController.dispose();
    selectedStatus.dispose();
    query.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        return FunctionHelper.handleSearchingOnPop(ref, didPop, isSearching);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isSearching ? 124 : 180),
          child: buildHeaderContainer(isSearching),
        ),
        body: Builder(
          builder: (context) {
            if (isSearching) {
              if (questions.isEmpty) {
                return const CustomInformation(
                  illustrationName: 'discussion-cuate.svg',
                  title: 'Pertanyaan tidak ditemukan',
                  subtitle: 'Pertanyaan dengan judul tersebut tidak ditemukan.',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                itemBuilder: (context, index) {
                  return const SizedBox();
                  // return DiscussionCard(
                  //   question: questions[index],
                  //   role: 'teacher',
                  //   isDetail: true,
                  //   withProfile: true,
                  // );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemCount: questions.length,
              );
            }

            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: (index) {
                switch (index) {
                  case 0:
                    selectedStatus.value = QuestionStatus.discuss;
                    break;
                  case 1:
                    selectedStatus.value = QuestionStatus.solved;
                    break;
                }
              },
              children: [
                QuestionListPage(
                  role: 'teacher',
                  questions: dummyQuestions
                      .map((e) => e.copyWith(status: 'discuss'))
                      .toList(),
                  isDetail: true,
                  withProfile: true,
                ),
                QuestionListPage(
                  role: 'teacher',
                  questions: dummyQuestions
                      .map((e) => e.copyWith(status: 'solved'))
                      .toList(),
                  isDetail: true,
                  withProfile: true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildHeaderContainer(bool isSearching) {
    if (isSearching) {
      return HeaderContainer(
        child: Column(
          children: [
            Text(
              'Cari Riwayat Pertanyaan',
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

    return SizedBox(
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          HeaderContainer(
            height: 180,
            title: 'Riwayat Pertanyaan',
            withBackButton: true,
            withTrailingButton: true,
            trailingButtonIconName: 'search-line.svg',
            trailingButtonTooltip: 'Cari',
            onPressedTrailingButton: () {
              ref.read(isSearchingProvider.notifier).state = true;
            },
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: ValueListenableBuilder(
              valueListenable: selectedStatus,
              builder: (context, type, child) {
                return SegmentedButton<QuestionStatus>(
                  segments: const [
                    ButtonSegment(
                      value: QuestionStatus.discuss,
                      label: Text('Dalam Diskusi'),
                    ),
                    ButtonSegment(
                      value: QuestionStatus.solved,
                      label: Text('Telah Selesai'),
                    ),
                  ],
                  selected: {type},
                  showSelectedIcon: false,
                  onSelectionChanged: (newSelection) {
                    selectedStatus.value = newSelection.first;

                    pageController.animateToPage(
                      newSelection.first.index - 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
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
