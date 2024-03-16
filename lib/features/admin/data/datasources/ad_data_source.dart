// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_model.dart';

abstract class AdDataSource {
  /// Get ads
  Future<List<AdModel>> getAds();

  /// Get ad detail
  Future<AdModel> getAdDetail({required int id});

  /// Create ads
  Future<void> createAd({
    required String title,
    required String content,
    required String imageName,
  });

  /// Edit ads
  Future<void> editAd({required AdModel ad});

  /// Edit ads
  Future<void> deleteAd({required int id});
}

class AdDataSourceImpl implements AdDataSource {
  final http.Client client;

  AdDataSourceImpl({
    required this.client,
  });

  @override
  Future<List<AdModel>> getAds() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/ads'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => AdModel.fromMap(e)).toList();
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
  Future<AdModel> getAdDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/ads/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as Map<String, dynamic>;

        return AdModel.fromMap(data);
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
  Future<void> createAd({
    required String title,
    required String content,
    required String imageName,
  }) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse('${ApiConfigs.baseUrl}/ads'),
      )
        ..fields.addAll({
          'title': title,
          'content': content,
        })
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${CredentialSaver.accessToken}';

      final file = await http.MultipartFile.fromPath(
        'file',
        imageName,
        filename: const Uuid().v4() + p.extension(imageName),
      );

      request.files.add(file);

      final stremedResponse = await request.send();
      final response = await http.Response.fromStream(stremedResponse);
      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
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
  Future<void> deleteAd({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/ads/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
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
  Future<void> editAd({required AdModel ad}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/ads/${ad.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}',
        },
        body: jsonEncode({
          'title': ad.title,
          'content': ad.content,
        }),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
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
}
