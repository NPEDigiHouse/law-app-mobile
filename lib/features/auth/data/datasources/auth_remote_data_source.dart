import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/services/api_service.dart';
import 'package:law_app/features/auth/data/models/user_register_model.dart';

abstract class AuthRemoteDataSource {
  Future<bool> signUp({required UserSignUpModel userSignUpModel});
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
          'Content-Type': 'application/json',
        },
        body: userSignUpModel.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      }

      throw ServerException(jsonDecode(response.body)['message']);
    } catch (e) {
      throw http.ClientException(e.toString());
    }
  }
}
