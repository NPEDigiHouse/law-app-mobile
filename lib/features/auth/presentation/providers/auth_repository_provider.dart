import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law_app/core/utils/http_client.dart';
import 'package:law_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:law_app/features/auth/data/repositories/auth_repository.dart';
import 'package:law_app/features/shared/providers/network_info_provider.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(client: HttpClient.client),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    authRemoteDataSource: ref.watch(authRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);
