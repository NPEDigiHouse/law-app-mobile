// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/helpers/auth_preferences_helper.dart';
import 'package:law_app/core/services/api_service.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';
import 'package:law_app/features/auth/data/models/user_credential_model.dart';
import 'package:law_app/features/shared/models/user_post_model.dart';

abstract class AuthDataSource {
  /// Sign up
  Future<bool> signUp({required UserPostModel userPostModel});

  /// Sign In
  Future<bool> signIn({required String username, required String password});

  /// Is sign in
  Future<bool> isSignIn();

  /// Get user credential
  Future<UserCredentialModel> getUserCredential();

  /// Log out
  Future<bool> logOut();
}

class AuthDataSourceImpl implements AuthDataSource {
  final http.Client client;
  final AuthPreferencesHelper preferencesHelper;

  AuthDataSourceImpl({
    required this.client,
    required this.preferencesHelper,
  });

  @override
  Future<bool> signUp({required UserPostModel userPostModel}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiService.baseUrl}/auth/signup'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: userPostModel.toJson(),
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

  @override
  Future<bool> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiService.baseUrl}/auth/login'),
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
      String? token = await preferencesHelper.getAccessToken();

      return token != null;
    } catch (e) {
      throw PreferenceException(e.toString());
    }
  }

  @override
  Future<UserCredentialModel> getUserCredential() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiService.baseUrl}/auth/credential'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as Map<String, dynamic>;

        return UserCredentialModel.fromMap(data);
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

      CredentialSaver.accessToken = null;

      return result;
    } catch (e) {
      throw PreferenceException(e.toString());
    }
  }
}
