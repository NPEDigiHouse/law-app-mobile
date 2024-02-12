import 'package:flutter/material.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';

class QuestionListPage extends StatefulWidget {
  final int roleId;
  final List<Question> questions;
  final bool isDetail;
  final bool withProfile;

  const QuestionListPage({
    super.key,
    required this.roleId,
    required this.questions,
    this.isDetail = false,
    this.withProfile = false,
  });

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage>
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