import 'package:flutter/material.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/routes.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';

class QuestionList extends StatefulWidget {
  final int roleId;
  final List<Question> questions;

  const QuestionList({
    super.key,
    required this.roleId,
    required this.questions,
  });

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
          question: widget.questions[index],
          isDetail: true,
          onTap: () => onItemTapped(index),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemCount: widget.questions.length,
    );
  }

  void onItemTapped(int index) {
    switch (widget.roleId) {
      case 0:
        break;
      case 1:
        navigatorKey.currentState!.pushNamed(
          studentDiscussionDetailRoute,
          arguments: widget.questions[index],
        );
        break;
      case 2:
        break;
      default:
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
