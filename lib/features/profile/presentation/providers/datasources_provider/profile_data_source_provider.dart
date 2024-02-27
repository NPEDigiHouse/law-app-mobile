// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/utils/http_client.dart';
import 'package:law_app/features/profile/data/datasources/profile_data_source.dart';

part 'profile_data_source_provider.g.dart';

@riverpod
ProfileDataSource profileDataSource(ProfileDataSourceRef ref) {
  return ProfileDataSourceImpl(client: HttpClient.client);
}
