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
import 'package:law_app/features/admin/data/models/discussion_models/discussion_model.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_post_model.dart';

abstract class DiscussionDataSource {
  /// Get user discussions
  Future<List<DiscussionModel>> getUserDiscussions({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  });

  /// Get all discussions
  Future<List<DiscussionModel>> getDiscussions({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  });

  /// Get discussion detail
  Future<DiscussionModel> getDiscussionDetail({required int id});

  /// Create discussion
  Future<void> createDiscussion({required DiscussionPostModel discussion});

  /// Edit discussion
  Future<void> editDiscussion({
    required int discussionId,
    int? handlerId,
    String? status,
    String? type,
  });

  /// Delete discussion
  Future<void> deleteDiscussion({required int id});

  // Create discussion answer
  Future<void> createDiscussionComment({
    required int userId,
    required int discussionId,
    required String text,
  });
}

class DiscussionDataSourceImpl implements DiscussionDataSource {
  final http.Client client;

  DiscussionDataSourceImpl({required this.client});

  @override
  Future<List<DiscussionModel>> getUserDiscussions({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  }) async {
    try {
      final queryParams =
          'term=$query&status=$status&type=$type&offset=${offset ?? ''}&limit=${limit ?? ''}&categoryId=${categoryId ?? ''}';

      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/auth/user-discussions?$queryParams'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => DiscussionModel.fromMap(e)).toList();
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<List<DiscussionModel>> getDiscussions({
    String query = '',
    String status = '',
    String type = '',
    int? offset,
    int? limit,
    int? categoryId,
  }) async {
    try {
      final queryParams =
          'term=$query&status=$status&type=$type&offset=${offset ?? ''}&limit=${limit ?? ''}&categoryId=${categoryId ?? ''}';

      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/user-discussions?$queryParams'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => DiscussionModel.fromMap(e)).toList();
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<DiscussionModel> getDiscussionDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/user-discussions/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return DiscussionModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createDiscussion(
      {required DiscussionPostModel discussion}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/user-discussions'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: discussion.toJson(),
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
  Future<void> editDiscussion({
    required int discussionId,
    int? handlerId,
    String? status,
    String? type,
  }) async {
    try {
      final body = {};

      if (handlerId != null) body['handlerId'] = handlerId;
      if (status != null) body['status'] = status;
      if (type != null) body['type'] = type;

      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/user-discussions/$discussionId'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode(body),
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
  Future<void> deleteDiscussion({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/user-discussions/$id'),
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
  Future<void> createDiscussionComment({
    required int userId,
    required int discussionId,
    required String text,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/discussion-comments'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'userId': userId,
          'discussionId': discussionId,
          'text': text,
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
}
