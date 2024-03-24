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
import 'package:law_app/features/admin/data/models/ad_models/ad_detail_model.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_model.dart';
import 'package:law_app/features/admin/data/models/ad_models/ad_post_model.dart';

abstract class AdDataSource {
  /// Get ads
  Future<List<AdModel>> getAds();

  /// Get ad detail
  Future<AdDetailModel> getAdDetail({required int id});

  /// Create ad
  Future<void> createAd({required AdPostModel ad});

  /// Edit ad
  Future<void> editAd({required AdDetailModel ad});

  /// Delete ad
  Future<void> deleteAd({required int id});
}

class AdDataSourceImpl implements AdDataSource {
  final http.Client client;

  AdDataSourceImpl({required this.client});

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
      exception(e);
    }
  }

  @override
  Future<AdDetailModel> getAdDetail({required int id}) async {
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
        return AdDetailModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createAd({required AdPostModel ad}) async {
    try {
      final file = await http.MultipartFile.fromPath(
        'file',
        ad.file,
        filename: const Uuid().v4() + p.extension(ad.file),
      );

      final request = http.MultipartRequest(
        "POST",
        Uri.parse('${ApiConfigs.baseUrl}/ads'),
      )
        ..fields.addAll({
          'title': ad.title,
          'content': ad.content,
        })
        ..files.add(file)
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${CredentialSaver.accessToken}';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> editAd({required AdDetailModel ad}) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConfigs.baseUrl}/ads/${ad.id}'),
      )
        ..fields.addAll({
          'title': '${ad.title}',
          'content': '${ad.content}',
        })
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${CredentialSaver.accessToken}';

      if (ad.imageName != null) {
        final file = await http.MultipartFile.fromPath(
          'file',
          ad.imageName!,
          filename: const Uuid().v4() + p.extension(ad.imageName!),
        );

        request.files.add(file);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
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
      exception(e);
    }
  }
}
