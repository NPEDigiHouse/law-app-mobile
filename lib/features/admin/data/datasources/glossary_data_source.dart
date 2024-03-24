// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';
import 'package:law_app/features/admin/data/models/glossary_models/glossary_model.dart';
import 'package:law_app/features/admin/data/models/glossary_models/glossary_post_model.dart';
import 'package:law_app/features/admin/data/models/glossary_models/glossary_search_history_model.dart';

abstract class GlossaryDataSource {
  /// Get glossaries
  Future<List<GlossaryModel>> getGlossaries({
    String query = '',
    int? offset,
    int? limit,
  });

  /// Get glossary detail
  Future<GlossaryModel> getGlossaryDetail({required int id});

  /// Create glossary
  Future<void> createGlossary({required GlossaryPostModel glossary});

  /// Edit glossary
  Future<void> editGlossary({required GlossaryModel glossary});

  /// Delete glossary
  Future<void> deleteGlossary({required int id});

  /// Create glossary search history
  Future<void> createGlossarySearchHistory({required int id});

  /// Get glossaries search history
  Future<List<GlossarySearchHistoryModel>> getGlossariesSearchHistory();

  /// Delete single glossary search history
  Future<void> deleteGlossarySearchHistory({required int id});

  /// Delete all glossaries search history
  Future<void> deleteAllGlossariesSearchHistory();
}

class GlossaryDataSourceImpl implements GlossaryDataSource {
  final http.Client client;

  GlossaryDataSourceImpl({required this.client});

  @override
  Future<List<GlossaryModel>> getGlossaries({
    String query = '',
    int? offset,
    int? limit,
  }) async {
    try {
      final queryParams =
          'term=$query&offset=${offset ?? ''}&limit=${limit ?? ''}';

      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/glosariums?$queryParams'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => GlossaryModel.fromMap(e)).toList();
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<GlossaryModel> getGlossaryDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/glosariums/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return GlossaryModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createGlossary({required GlossaryPostModel glossary}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/glosariums'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: glossary.toJson(),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> editGlossary({required GlossaryModel glossary}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/glosariums/${glossary.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'title': glossary.title,
          'description': glossary.description,
        }),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> deleteGlossary({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/glosariums/$id'),
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

  @override
  Future<void> createGlossarySearchHistory({required int id}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/glosariums-search-histories'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({'glosariumId': id}),
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code != 200) {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<List<GlossarySearchHistoryModel>> getGlossariesSearchHistory() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/glosariums-search-histories'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => GlossarySearchHistoryModel.fromMap(e)).toList();
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> deleteGlossarySearchHistory({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/glosariums-search-histories/$id'),
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

  @override
  Future<void> deleteAllGlossariesSearchHistory() async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/glosariums-search-histories/all'),
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
