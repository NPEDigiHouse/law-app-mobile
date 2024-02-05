import 'package:flutter/material.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/discussion_card.dart';

class MyQuestionList extends StatefulWidget {
  final List<Question> questionList;

  const MyQuestionList({super.key, required this.questionList});

  @override
  State<MyQuestionList> createState() => _MyQuestionListState();
}

class _MyQuestionListState extends State<MyQuestionList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      itemBuilder: (context, index) {
        return DiscussionCard(
          question: widget.questionList[index],
          isDetail: true,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemCount: widget.questionList.length,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
