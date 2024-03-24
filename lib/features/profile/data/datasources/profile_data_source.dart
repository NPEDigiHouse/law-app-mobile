// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';
import 'package:law_app/features/admin/data/models/user_models/user_detail_model.dart';

abstract class ProfileDataSource {
  /// Get profile detail
  Future<UserDetailModel> getProfileDetail({required int id});

  /// Edit profile
  Future<void> editProfile({
    required UserDetailModel user,
    String? path,
  });

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
  Future<UserDetailModel> getProfileDetail({required int id}) async {
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
        return UserDetailModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> editProfile({
    required UserDetailModel user,
    String? path,
  }) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConfigs.baseUrl}/users/${user.id}'),
      )
        ..fields.addAll({
          'name': '${user.name}',
          'email': '${user.email}',
          'phoneNumber': '${user.phoneNumber}',
          'teacherDiscussionCategoryIds':
              '${user.expertises?.map((e) => e.id).toList()}',
          'birthDate':
              '${user.birthDate?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'")}',
        })
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${CredentialSaver.accessToken}';

      if (path != null) {
        final file = await http.MultipartFile.fromPath(
          'profilePicture',
          path,
          filename: const Uuid().v4() + p.extension(path),
        );

        request.files.add(file);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
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
      exception(e);
    }
  }
}
