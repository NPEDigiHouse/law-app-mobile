// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';

class AdminQuestionListPage extends StatefulWidget {
  final List<Question> questions;
  final bool isDetail;
  final bool withProfile;

  const AdminQuestionListPage({
    super.key,
    required this.questions,
    this.isDetail = false,
    this.withProfile = false,
  });

  @override
  State<AdminQuestionListPage> createState() => _AdminQuestionListPageState();
}

class _AdminQuestionListPageState extends State<AdminQuestionListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.questions.isEmpty) {
      return const Center(
        child: CustomInformation(
          illustrationName: 'discussion-cuate.svg',
          title: 'Diskusi tidak ditemukan',
          subtitle: 'Judul diskusi tersebut tidak ditemukan.',
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      itemBuilder: (context, index) {
        return const SizedBox();
        // return DiscussionCard(
        //   question: widget.questions[index],
        //   role: "admin",
        //   isDetail: widget.isDetail,
        //   withProfile: widget.withProfile,
        // );
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
