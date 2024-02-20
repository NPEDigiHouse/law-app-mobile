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
      final uri = Uri.parse('${ApiService.baseUrl}/auth/signup');

      final response = await client.post(
        uri,
        headers: {
          "content-type": 'application/json',
          "authorization": 'Basic ${ApiService.token}'
        },
        body: userSignUpModel.toMap(),
      );

      if (response.statusCode == 200) {
        return true;
      }

      throw const ServerException('server_error');
    } catch (_) {
      throw http.ClientException('client_error');
    }
  }
}
