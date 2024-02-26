import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/enums/question_type.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/admin/presentation/discussion/widgets/admin_question_list_page.dart';
import 'package:law_app/features/shared/providers/search_provider.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/text_field/search_field.dart';

class AdminDiscussionHomePage extends ConsumerStatefulWidget {
  const AdminDiscussionHomePage({super.key});

  @override
  ConsumerState<AdminDiscussionHomePage> createState() =>
      _AdminDiscussionHomePageState();
}

class _AdminDiscussionHomePageState
    extends ConsumerState<AdminDiscussionHomePage> {
  late final List<String> status;
  late final ValueNotifier<String> selectedStatus;
  late final ValueNotifier<QuestionType> selectedType;
  late final PageController pageController;
  late List<Question> items;

  late final ValueNotifier<String> query;

  @override
  void initState() {
    super.initState();

    status = ['Semua', 'Open', 'Discuss', 'Solved'];
    items = dummyQuestions;
    selectedStatus = ValueNotifier(status.first);
    query = ValueNotifier('');
    selectedType = ValueNotifier(QuestionType.general);
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();

    selectedType.dispose();
    selectedStatus.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: SizedBox(
          height: isSearching ? 220 : 180,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  color: scaffoldBackgroundColor,
                ),
              ),
              buildHeaderContainer(isSearching),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: ValueListenableBuilder(
                  valueListenable: selectedType,
                  builder: (context, type, child) {
                    return SegmentedButton<QuestionType>(
                      segments: const [
                        ButtonSegment(
                          value: QuestionType.general,
                          label: Text('Pertanyaan Umum'),
                        ),
                        ButtonSegment(
                          value: QuestionType.specific,
                          label: Text('Pertanyaan Khusus'),
                        ),
                      ],
                      selected: {type},
                      showSelectedIcon: false,
                      onSelectionChanged: (newSelection) {
                        selectedType.value = newSelection.first;
                        pageController.animateToPage(
                          newSelection.first.index,
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
        ),
      ),
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 64,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: -1,
                  ),
                ],
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                    valueListenable: selectedStatus,
                    builder: (context, status, child) {
                      return CustomFilterChip(
                        label: this.status[index],
                        selected: status == this.status[index],
                        onSelected: (_) {
                          selectedStatus.value = this.status[index];
                        },
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemCount: status.length,
              ),
            ),
          ),
          SliverFillRemaining(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: (index) {
                switch (index) {
                  case 0:
                    selectedType.value = QuestionType.general;
                    break;
                  case 1:
                    selectedType.value = QuestionType.specific;
                    break;
                }
              },
              children: [
                AdminQuestionListPage(
                  withProfile: true,
                  isDetail: true,
                  questions:
                      items.map((e) => e.copyWith(type: 'general')).toList(),
                ),
                AdminQuestionListPage(
                  withProfile: true,
                  isDetail: true,
                  questions:
                      items.map((e) => e.copyWith(type: 'specific')).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  HeaderContainer buildHeaderContainer(bool isSearching) {
    if (isSearching) {
      return HeaderContainer(
        child: Column(
          children: [
            Text(
              'Cari Diskusi',
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
                  hintText: 'Cari judul diskusi',
                  autoFocus: true,
                  onChanged: searchDiscussion,
                  onTapSuffixIcon: () {
                    ref.read(isSearchingProvider.notifier).state = false;
                  },
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
      title: 'Kelola Pertanyaan',
      withBackButton: true,
      height: 180,
      withTrailingButton: true,
      trailingButtonIconName: "search-line.svg",
      trailingButtonTooltip: "Cari",
      onPressedTrailingButton: () =>
          ref.read(isSearchingProvider.notifier).state = true,
    );
  }

  void searchDiscussion(String query) {
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

        setState(() => items = result);
      },
    );

    if (query.isEmpty) {
      EasyDebounce.fire('search-debouncer');
    }
  }
}
