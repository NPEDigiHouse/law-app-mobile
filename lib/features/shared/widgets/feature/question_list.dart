import 'package:flutter/material.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';

class QuestionList extends StatefulWidget {
  final List<Question> questions;
  final int roleId;
  final bool isDetail;
  final bool withProfile;

  const QuestionList({
    super.key,
    required this.questions,
    required this.roleId,
    this.isDetail = false,
    this.withProfile = false,
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
          roleId: widget.roleId,
          isDetail: widget.isDetail,
          withProfile: widget.withProfile,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemCount: widget.questions.length,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
