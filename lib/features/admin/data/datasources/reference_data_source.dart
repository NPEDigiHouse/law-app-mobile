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
import 'package:law_app/features/admin/data/models/reference_models/contact_us_model.dart';
import 'package:law_app/features/admin/data/models/reference_models/discussion_category_model.dart';
import 'package:law_app/features/admin/data/models/reference_models/faq_model.dart';

abstract class ReferenceDataSource {
  /// Get discussion categories
  Future<List<DiscussionCategoryModel>> getDiscussionCategories();

  /// Create discussion category
  Future<void> createDiscussionCategory({required String name});

  /// Edit discussion category
  Future<void> editDiscussionCategory(
      {required DiscussionCategoryModel category});

  /// Delete discussion category
  Future<void> deleteDiscussionCategory({required int id});

  /// Get FAQs
  Future<List<FAQModel>> getFAQs();

  /// Create FAQ
  Future<void> createFAQ({
    required String question,
    required String answer,
  });

  /// Edit FAQ
  Future<void> editFAQ({required FAQModel faq});

  /// Delete FAQ
  Future<void> deleteFAQ({required int id});

  /// Get contact us
  Future<ContactUsModel?> getContactUs();

  /// Edit contact us
  Future<void> editContactUs({required ContactUsModel contact});
}

class ReferenceDataSourceImpl implements ReferenceDataSource {
  final http.Client client;

  ReferenceDataSourceImpl({required this.client});

  @override
  Future<List<DiscussionCategoryModel>> getDiscussionCategories() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/discussion-categories'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => DiscussionCategoryModel.fromMap(e)).toList();
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
  Future<void> createDiscussionCategory({required String name}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/discussion-categories'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({'name': name}),
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
  Future<void> editDiscussionCategory(
      {required DiscussionCategoryModel category}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/discussion-categories/${category.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({'name': category.name}),
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
  Future<void> deleteDiscussionCategory({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/discussion-categories/$id'),
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
  Future<List<FAQModel>> getFAQs() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/faqs'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => FAQModel.fromMap(e)).toList();
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
  Future<void> createFAQ({
    required String question,
    required String answer,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/faqs'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'question': question,
          'answer': answer,
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

  @override
  Future<void> editFAQ({required FAQModel faq}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/faqs/${faq.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'question': faq.question,
          'answer': faq.answer,
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

  @override
  Future<void> deleteFAQ({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/faqs/$id'),
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
  Future<ContactUsModel?> getContactUs() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/contact-us'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return result.data != null ? ContactUsModel.fromMap(result.data) : null;
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
  Future<void> editContactUs({required ContactUsModel contact}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/contact-us'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: contact.toJson(),
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
