// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/repositories/discussion_repository.dart';
import 'package:law_app/features/shared/providers/discussion_providers/datasources_provider/discussion_data_source_provider.dart';
import 'package:law_app/features/shared/providers/generated_providers/network_info_provider.dart';

part 'discussion_repository_provider.g.dart';

@riverpod
DiscussionRepository discussionRepository(DiscussionRepositoryRef ref) {
  return DiscussionRepositoryImpl(
    discussionDataSource: ref.watch(discussionDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
