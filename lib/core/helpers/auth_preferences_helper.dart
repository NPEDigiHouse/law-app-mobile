// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/auth/data/models/user_credential_model.dart';

class AuthPreferencesHelper {
  /// Singleton class
  static AuthPreferencesHelper? _instance;

  AuthPreferencesHelper._internal() {
    _instance = this;
  }

  factory AuthPreferencesHelper() =>
      _instance ?? AuthPreferencesHelper._internal();

  /// Singleton shared preferences
  static SharedPreferences? _preferences;

  Future<SharedPreferences> _initPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<SharedPreferences?> get preferences async {
    return _preferences ??= await _initPreferences();
  }

  Future<bool> setAccessToken(String token) async {
    final pr = await preferences;

    return await pr!.setString(accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    final pr = await preferences;

    if (pr!.containsKey(accessTokenKey)) {
      final token = pr.getString(accessTokenKey);

      CredentialSaver.accessToken ??= token;

      return token;
    }

    return null;
  }

  Future<bool> removeAccessToken() async {
    CredentialSaver.accessToken = null;

    final pr = await preferences;

    return await pr!.remove(accessTokenKey);
  }

  Future<bool> setUserCredential(UserCredentialModel userCredential) async {
    final pr = await preferences;

    return await pr!.setString(userCredentialKey, userCredential.toJson());
  }

  Future<UserCredentialModel?> getUserCredential() async {
    final pr = await preferences;

    if (pr!.containsKey(userCredentialKey)) {
      final data = pr.getString(userCredentialKey);

      final userCredential = UserCredentialModel.fromJson(data ?? '');

      CredentialSaver.user ??= userCredential;

      return userCredential;
    }

    return null;
  }

  Future<bool> removeUserCredential() async {
    CredentialSaver.user = null;

    final pr = await preferences;

    return await pr!.remove(userCredentialKey);
  }
}
