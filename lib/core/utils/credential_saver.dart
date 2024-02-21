import 'package:law_app/core/helpers/auth_preferences_helper.dart';

class CredentialSaver {
  static String? accessToken;

  static init() async {
    if (accessToken == null) {
      AuthPreferencesHelper preferencesHelper = AuthPreferencesHelper();

      accessToken = await preferencesHelper.getAccessToken();

      print(accessToken);
    }
  }
}
