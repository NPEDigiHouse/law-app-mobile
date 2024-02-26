// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';
import 'package:law_app/features/shared/models/user_model.dart';
import 'package:law_app/features/shared/models/user_post_model.dart';

abstract class MasterDataSource {
  /// Get Users
  Future<List<UserModel>> getUsers({
    String query = '',
    String sortBy = '',
    String sortOrder = '',
    String? role,
  });

  /// Get user detail
  Future<UserModel> getUserDetail({required int id});

  /// Create user
  Future<void> createUser({required UserPostModel user});

  /// Edit user
  Future<void> editUser({required UserModel user});

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
          '${ApiConfigs.baseUrl}/users?${role != null ? 'role=$role' : queryParams}',
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
  Future<UserModel> getUserDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/users/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return UserModel.fromMap(result.data);
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
  Future<void> createUser({required UserPostModel user}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/auth/signup'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: user.toJson(),
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

  @override
  Future<void> editUser({required UserModel user}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/users/${user.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'birthDate':
              user.birthDate?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
          'phoneNumber': user.phoneNumber,
        }),
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

  @override
  Future<void> deleteUser({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/users/$id'),
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
