// Project imports:
import 'package:law_app/core/helpers/auth_preferences_helper.dart';
import 'package:law_app/features/auth/data/models/user_credential_model.dart';

class CredentialSaver {
  static String? accessToken;
  static UserCredentialModel? user;

  static init() async {
    if (accessToken == null && user == null) {
      AuthPreferencesHelper preferencesHelper = AuthPreferencesHelper();

      accessToken = await preferencesHelper.getAccessToken();
      user = await preferencesHelper.getUserCredential();
    }
  }
}
