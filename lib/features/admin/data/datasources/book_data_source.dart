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
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_post_model.dart';

abstract class BookDataSource {
  // Get all books
  Future<List<BookModel>> getBooks({
    String query = '',
    int? offset,
    int? limit,
    int? categoryId,
  });

  /// Get book detail
  Future<BookDetailModel> getBookDetail({required int id});

  /// Create book
  Future<void> createBook({
    required BookPostModel book,
    required String imagePath,
    required String filePath,
  });

  /// Edit book
  Future<void> editBook({
    required BookModel book,
    String? imagePath,
    String? filePath,
  });

  /// Delete book
  Future<void> deleteBook({required int id});

  /// Get book categories
  Future<List<BookCategoryModel>> getBookCategories();

  /// Create book categories
  Future<void> createBookCategory({required String name});

  /// Edit book categories
  Future<void> editBookCategory({required BookCategoryModel category});

  /// Delete book categories
  Future<void> deleteBookCategory({required int id});
}

class BookDataSourceImpl implements BookDataSource {
  final http.Client client;

  BookDataSourceImpl({required this.client});

  @override
  Future<List<BookModel>> getBooks({
    String query = '',
    int? offset,
    int? limit,
    int? categoryId,
  }) async {
    try {
      final queryParams =
          'offset=${offset ?? ''}&limit=${limit ?? ''}&term=$query&categoryId=${categoryId ?? ''}';

      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/books?$queryParams'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => BookModel.fromMap(e)).toList();
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
  Future<BookDetailModel> getBookDetail({required int id}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/books/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        return BookDetailModel.fromMap(result.data);
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
  Future<void> createBook({
    required BookPostModel book,
    required String filePath,
    required String imagePath,
  }) async {
    try {
      final file = await http.MultipartFile.fromPath('files', filePath);
      final image = await http.MultipartFile.fromPath('files', imagePath);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfigs.baseUrl}/books'),
      )
        ..fields.addAll(book.toMap())
        ..files.addAll([file, image])
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${CredentialSaver.accessToken}';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
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
  Future<void> editBook({
    required BookModel book,
    String? filePath,
    String? imagePath,
  }) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConfigs.baseUrl}/books'),
      )
        // ..fields.addAll(book.toMap())
        // ..files.addAll([file, image])
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${CredentialSaver.accessToken}';

      if (filePath != null) {
        final file = await http.MultipartFile.fromPath('files', filePath);

        request.files.add(file);
      }

      if (imagePath != null) {
        final image = await http.MultipartFile.fromPath('files', imagePath);

        request.files.add(image);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
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
  Future<void> deleteBook({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/books/$id'),
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
  Future<List<BookCategoryModel>> getBookCategories() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/book-categories'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => BookCategoryModel.fromMap(e)).toList();
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
  Future<void> createBookCategory({required String name}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/book-categories'),
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
  Future<void> editBookCategory({required BookCategoryModel category}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/book-categories/${category.id}'),
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
  Future<void> deleteBookCategory({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/book-categories/$id'),
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
}
