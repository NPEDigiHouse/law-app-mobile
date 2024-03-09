// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';
import 'package:law_app/features/admin/data/models/user_models/user_credential_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_post_model.dart';
import 'package:law_app/features/auth/data/datasources/auth_preferences_helper.dart';

abstract class AuthDataSource {
  /// Sign up
  Future<bool> signUp({required UserPostModel user});

  /// Sign In
  Future<bool> signIn({
    required String username,
    required String password,
  });

  /// Is sign in
  Future<bool> isSignIn();

  /// Get user credential
  Future<UserCredentialModel> getUserCredential();

  /// Log out
  Future<bool> logOut();

  /// Ask reset password
  Future<String> askResetPassword({required String email});

  /// Reset password
  Future<bool> resetPassword({
    required String email,
    required String resetPasswordToken,
    required String newPassword,
  });
}

class AuthDataSourceImpl implements AuthDataSource {
  final http.Client client;
  final AuthPreferencesHelper preferencesHelper;

  AuthDataSourceImpl({
    required this.client,
    required this.preferencesHelper,
  });

  @override
  Future<bool> signUp({required UserPostModel user}) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfigs.baseUrl}/auth/signup'),
      )..fields.addAll(user.toMap());

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return true;
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
  Future<bool> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/auth/login'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final token = result.data as String;
        final isSet = await preferencesHelper.setAccessToken(token);

        CredentialSaver.accessToken = token;

        return isSet;
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
  Future<bool> isSignIn() async {
    try {
      final token = await preferencesHelper.getAccessToken();
      final userCredential = await preferencesHelper.getUserCredential();

      return token != null && userCredential != null;
    } catch (e) {
      throw PreferenceException(e.toString());
    }
  }

  @override
  Future<UserCredentialModel> getUserCredential() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/auth/credential'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final userData = result.data as Map<String, dynamic>;
        final userCredential = UserCredentialModel.fromMap(userData);

        await preferencesHelper.setUserCredential(userCredential);

        CredentialSaver.user = userCredential;

        return userCredential;
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
  Future<bool> logOut() async {
    try {
      final result = await preferencesHelper.removeAccessToken();
      final result2 = await preferencesHelper.removeUserCredential();

      CredentialSaver.accessToken = null;
      CredentialSaver.user = null;

      return result && result2;
    } catch (e) {
      throw PreferenceException(e.toString());
    }
  }

  @override
  Future<String> askResetPassword({required String email}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/users/ask-reset-password'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return result.data['resetToken'] as String;
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
  Future<bool> resetPassword({
    required String email,
    required String resetPasswordToken,
    required String newPassword,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/users/reset-password'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'resetPasswordToken': resetPasswordToken,
          'newPassword': newPassword,
        }),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return true;
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
}
