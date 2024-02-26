// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:law_app/features/shared/models/user_model.dart';

abstract class ProfileDataSource {
  /// Get profile detail
  Future<UserModel> getProfileDetail({required int id});

  /// Edit profile
  Future<void> editProfile({required UserModel user});

  /// Upload profile picture
  Future<String> uploadProfilePicture(String path, String filename);

  /// Delete profile picture
  Future<void> deleteProfilePicture(String filename);
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final http.Client client;

  ProfileDataSourceImpl({required this.client});

  @override
  Future<UserModel> getProfileDetail({required int id}) async {
    // TODO: implement getProfileDetail
    throw UnimplementedError();
  }

  @override
  Future<void> editProfile({required UserModel user}) async {
    // TODO: implement editProfile
    throw UnimplementedError();
  }

  @override
  Future<String> uploadProfilePicture(String path, String filename) async {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProfilePicture(String filename) async {
    // TODO: implement deleteProfilePicture
    throw UnimplementedError();
  }
}
