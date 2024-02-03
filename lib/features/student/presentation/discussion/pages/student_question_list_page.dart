import 'package:flutter/material.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/custom_filter_chip.dart';
import 'package:law_app/features/shared/widgets/discussion_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

enum QuestionTypes { general, specific }

class StudentQuestionListPage extends StatefulWidget {
  const StudentQuestionListPage({super.key});

  @override
  State<StudentQuestionListPage> createState() =>
      _StudentQuestionListPageState();
}

class _StudentQuestionListPageState extends State<StudentQuestionListPage> {
  late final List<String> questionStatus;
  late final ValueNotifier<String> selectedStatus;
  late final ValueNotifier<QuestionTypes> selectedType;

  @override
  void initState() {
    super.initState();

    questionStatus = ['Semua', 'Open', 'Discuss', 'Solved'];
    selectedStatus = ValueNotifier(questionStatus[0]);
    selectedType = ValueNotifier(QuestionTypes.general);
  }

  @override
  void dispose() {
    super.dispose();

    selectedType.dispose();
    selectedStatus.dispose();
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
                    return SegmentedButton<QuestionTypes>(
                      segments: const [
                        ButtonSegment(
                          value: QuestionTypes.general,
                          label: Text('Pertanyaan Umum'),
                        ),
                        ButtonSegment(
                          value: QuestionTypes.specific,
                          label: Text('Pertanyaan Khusus'),
                        ),
                      ],
                      selected: {type},
                      showSelectedIcon: false,
                      onSelectionChanged: (newSelection) {
                        selectedType.value = newSelection.first;
                      },
                      style: getSegmentedButtonStyle(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 64,
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
                    final selected = status == questionStatus[index];

                    return CustomFilterChip(
                      label: questionStatus[index],
                      selected: selected,
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
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              itemBuilder: (context, index) {
                return DiscussionCard(
                  question: questions[index],
                  isDetail: true,
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
              itemCount: questions.length,
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle getSegmentedButtonStyle() {
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }

        return secondaryTextColor;
      }),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return secondaryColor;
        }

        return scaffoldBackgroundColor;
      }),
      textStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return textTheme.titleSmall;
        }

        return textTheme.bodyMedium;
      }),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      side: MaterialStateProperty.all(
        const BorderSide(
          style: BorderStyle.none,
        ),
      ),
      visualDensity: const VisualDensity(vertical: -2),
    );
  }
}
