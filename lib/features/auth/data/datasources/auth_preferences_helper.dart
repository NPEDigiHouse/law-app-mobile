// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/features/admin/data/models/user_models/user_credential_model.dart';

class AuthPreferencesHelper {
  static AuthPreferencesHelper? _instance;

  AuthPreferencesHelper._internal() {
    _instance = this;
  }

  factory AuthPreferencesHelper() =>
      _instance ?? AuthPreferencesHelper._internal();

  SharedPreferences? _preferences;

  Future<SharedPreferences> _initPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<SharedPreferences?> get preferences async {
    return _preferences ??= await _initPreferences();
  }

  /// Set [accessToken] to persistent storage
  Future<bool> setAccessToken(String accessToken) async {
    final pr = await preferences;

    return await pr!.setString(accessTokenKey, accessToken);
  }

  /// Get access token from persistent storage
  Future<String?> getAccessToken() async {
    final pr = await preferences;

    if (pr!.containsKey(accessTokenKey)) {
      final token = pr.getString(accessTokenKey);

      CredentialSaver.accessToken ??= token;

      return token;
    }

    return null;
  }

  /// Remove access token from persistent storage
  Future<bool> removeAccessToken() async {
    CredentialSaver.accessToken = null;

    final pr = await preferences;

    return await pr!.remove(accessTokenKey);
  }

  /// Set [userCredential] to persistent storage
  Future<bool> setUserCredential(UserCredentialModel userCredential) async {
    final pr = await preferences;

    return await pr!.setString(userCredentialKey, userCredential.toJson());
  }

  /// Get user credential from persistent storage
  Future<UserCredentialModel?> getUserCredential() async {
    final pr = await preferences;

    if (pr!.containsKey(userCredentialKey)) {
      final data = pr.getString(userCredentialKey);

      final userCredential = UserCredentialModel.fromJson(data!);

      CredentialSaver.user ??= userCredential;

      return userCredential;
    }

    return null;
  }

  /// Remove user credential from persistent storage
  Future<bool> removeUserCredential() async {
    CredentialSaver.user = null;

    final pr = await preferences;

    return await pr!.remove(userCredentialKey);
  }

  /// Set [fcmToken] to persistent storage
  Future<bool> setFcmToken(String fcmToken) async {
    final pr = await preferences;

    return await pr!.setString(fcmTokenKey, fcmToken);
  }

  /// Get fcm token from persistent storage
  Future<String?> getFcmToken() async {
    final pr = await preferences;

    return pr!.getString(fcmTokenKey);
  }

  /// Remove fcm token from persistent storage
  Future<bool> removeFcmToken() async {
    final pr = await preferences;

    return await pr!.remove(fcmTokenKey);
  }
}
