import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/services/api_service.dart';
import 'package:law_app/features/auth/data/models/user_register_model.dart';

abstract class AuthRemoteDataSource {
  // Sign up
  Future<bool> signUp({required UserSignUpModel userSignUpModel});

  // Sign In
  Future<bool> signIn({required String username, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

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

      if (jsonDecode(response.body)['code'] == 200) {
        return true;
      } else {
        throw ServerException(jsonDecode(response.body)['message']);
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

      if (jsonDecode(response.body)['code'] == 200) {
        return true;
      } else {
        throw ServerException(jsonDecode(response.body)['message']);
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
