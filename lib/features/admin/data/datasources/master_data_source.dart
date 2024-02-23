// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/services/api_service.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';
import 'package:law_app/features/admin/data/models/user_model.dart';

abstract class MasterDataSource {
  /// Get Users
  Future<List<UserModel>> getUsers({
    String query = '',
    String sortBy = '',
    String sortOrder = '',
    String? role,
  });

  /// Delete user
  Future<void> deleteUser({required int id});
}

class MasterDataSourceImpl implements MasterDataSource {
  final http.Client client;

  MasterDataSourceImpl({required this.client});

  @override
  Future<List<UserModel>> getUsers({
    String query = '',
    String sortBy = '',
    String sortOrder = '',
    String? role,
  }) async {
    try {
      final queryParams = 'term=$query&sortBy=$sortBy&sortOrder=$sortOrder';

      final response = await client.get(
        Uri.parse(
          '${ApiService.baseUrl}/users?${role != null ? 'role=$role' : queryParams}',
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        final users = data.map((e) => UserModel.fromMap(e)).toList();

        return users;
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else {
        throw http.ClientException(e.toString());
      }
    }
  }

  @override
  Future<void> deleteUser({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiService.baseUrl}/users/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else {
        throw http.ClientException(e.toString());
      }
    }
  }
}
