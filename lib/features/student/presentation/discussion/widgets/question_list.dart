import 'package:flutter/material.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/discussion_card.dart';

class QuestionList extends StatefulWidget {
  const QuestionList({super.key});

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.separated(
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
