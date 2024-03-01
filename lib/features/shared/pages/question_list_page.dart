// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';

class QuestionListPage extends ConsumerStatefulWidget {
  final List<DiscussionModel> discussions;
  final bool isDetail;
  final bool withProfile;

  const QuestionListPage({
    super.key,
    required this.discussions,
    this.isDetail = false,
    this.withProfile = false,
  });

  @override
  ConsumerState<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends ConsumerState<QuestionListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      itemBuilder: (context, index) {
        return DiscussionCard(
          discussion: widget.discussions[index],
          isDetail: widget.isDetail,
          withProfile: widget.withProfile,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemCount: widget.discussions.length,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
