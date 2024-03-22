// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/discussion_card.dart';

class DiscussionListPage extends StatelessWidget {
  final List<DiscussionModel> discussions;
  final bool hasMore;
  final bool isDetail;
  final bool withProfile;
  final VoidCallback? onFetchMoreItems;

  const DiscussionListPage({
    super.key,
    required this.discussions,
    this.hasMore = false,
    this.isDetail = false,
    this.withProfile = false,
    this.onFetchMoreItems,
  });

  @override
  Widget build(BuildContext context) {
    if (discussions.isEmpty) {
      return const CustomInformation(
        illustrationName: 'house-searching-cuate.svg',
        title: 'Belum ada diskusi',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      itemBuilder: (context, index) {
        if (index >= discussions.length) {
          return TextButton(
            onPressed: onFetchMoreItems,
            child: const Text('Lihat lebih banyak'),
          );
        }

        return DiscussionCard(
          discussion: discussions[index],
          isDetail: isDetail,
          withProfile: withProfile,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemCount: hasMore ? discussions.length + 1 : discussions.length,
    );
  }
}
