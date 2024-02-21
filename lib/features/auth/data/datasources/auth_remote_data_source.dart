import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/helpers/auth_preferences_helper.dart';
import 'package:law_app/core/services/api_service.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';
import 'package:law_app/features/auth/data/models/user_register_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign up
  Future<bool> signUp({required UserSignUpModel userSignUpModel});

  /// Sign In
  Future<bool> signIn({required String username, required String password});

  /// Is sign in
  Future<bool> isSignIn();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final AuthPreferencesHelper preferencesHelper;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.preferencesHelper,
  });

  @override
  Future<bool> signUp({required UserSignUpModel userSignUpModel}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiService.baseUrl}/auth/signup'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: userSignUpModel.toJson(),
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
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final token = result.data as String;

        preferencesHelper.setAccessToken(token);

        CredentialSaver.accessToken = token;

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
  Future<bool> isSignIn() async {
    try {
      String? token = await preferencesHelper.getAccessToken();

      return token != null;
    } catch (e) {
      throw PreferenceException(e.toString());
    }
  }
}
