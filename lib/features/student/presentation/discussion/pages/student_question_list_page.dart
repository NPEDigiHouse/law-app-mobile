import 'package:flutter/material.dart';
import 'package:law_app/core/enums/question_type.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/pages/question_list_page.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class StudentQuestionListPage extends StatefulWidget {
  const StudentQuestionListPage({super.key});

  @override
  State<StudentQuestionListPage> createState() =>
      _StudentQuestionListPageState();
}

class _StudentQuestionListPageState extends State<StudentQuestionListPage> {
  late final List<String> questionStatus;
  late final ValueNotifier<String> selectedStatus;
  late final ValueNotifier<QuestionType> selectedType;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();

    questionStatus = ['Semua', 'Open', 'Discuss', 'Solved'];
    selectedStatus = ValueNotifier(questionStatus[0]);
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: SizedBox(
          height: 180,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const HeaderContainer(
                title: 'Pertanyaan Saya',
                withBackButton: true,
                height: 180,
              ),
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
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeIn,
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
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
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
                        label: questionStatus[index],
                        selected: status == questionStatus[index],
                        onSelected: (_) {
                          selectedStatus.value = questionStatus[index];
                        },
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
                itemCount: questionStatus.length,
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
                QuestionListPage(
                  roleId: 1,
                  questions: dummyQuestions.where((question) {
                    return question.type == QuestionType.general.name;
                  }).toList(),
                ),
                QuestionListPage(
                  roleId: 1,
                  questions: dummyQuestions.where((question) {
                    return question.type == QuestionType.specific.name;
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
