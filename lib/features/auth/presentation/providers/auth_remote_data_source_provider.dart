// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/core/helpers/auth_preferences_helper.dart';
import 'package:law_app/core/utils/http_client.dart';
import 'package:law_app/features/auth/data/datasources/auth_remote_data_source.dart';

part 'auth_remote_data_source_provider.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  return AuthRemoteDataSourceImpl(
    client: HttpClient.client,
    preferencesHelper: AuthPreferencesHelper(),
  );
}
