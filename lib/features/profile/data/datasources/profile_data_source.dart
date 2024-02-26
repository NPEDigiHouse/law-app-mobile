// Package imports:
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';

// Project imports:
import 'package:law_app/features/shared/models/user_model.dart';

abstract class ProfileDataSource {
  /// Get profile detail
  Future<UserModel> getProfileDetail({required int id});

  /// Edit profile
  Future<void> editProfile({
    required UserModel user,
    String? path,
  });

  /// Delete profile picture
  Future<void> deleteProfilePicture({required UserModel user});

  /// Change password
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  });
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final http.Client client;

  ProfileDataSourceImpl({required this.client});

  @override
  Future<UserModel> getProfileDetail({required int id}) async {
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
  Future<void> editProfile({
    required UserModel user,
    String? path,
  }) async {
    try {
      String? fileEncode;

      if (path != null) {
        fileEncode = base64Encode(File(path).readAsBytesSync());
      }

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
          'phoneNumber': user.phoneNumber,
          'profilePicture': path != null
              ? 'data:image/png;base64,$fileEncode'
              : user.profilePicture,
          'birthDate':
              user.birthDate?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
        }),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw http.ClientException(e.toString());
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> deleteProfilePicture({required UserModel user}) async {
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
          'phoneNumber': user.phoneNumber,
          'profilePicture': null,
          'birthDate':
              user.birthDate?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
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
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/users/change-password'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'email': email,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
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
}
