// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:law_app/core/configs/api_configs.dart';
import 'package:law_app/core/enums/book_file_type.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/data_response.dart';
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_post_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_saved_model.dart';

abstract class BookDataSource {
  /// Get book categories
  Future<List<BookCategoryModel>> getBookCategories();

  /// Create book category
  Future<void> createBookCategory({required String name});

  /// Edit book category
  Future<void> editBookCategory({required BookCategoryModel category});

  /// Delete book category
  Future<void> deleteBookCategory({required int id});

  // Get all books
  Future<List<BookModel>> getBooks({
    String query = '',
    int? offset,
    int? limit,
    int? categoryId,
  });

  /// Get book detail
  Future<BookModel> getBookDetail({required int id});

  /// Create book
  Future<void> createBook({
    required BookPostModel book,
    required String bookPath,
    required String imagePath,
  });

  /// Edit book file
  Future<void> editBookFile({
    required int id,
    required String path,
    required BookFileType type,
  });

  /// Edit book
  Future<void> editBook({required BookModel book});

  /// Delete book
  Future<void> deleteBook({required int id});

  /// Get all saved books
  Future<List<BookSavedModel>> getSavedBooks({required int userId});

  /// Save book
  Future<void> saveBook({required int bookId});

  /// Unsave book
  Future<void> unsaveBook({required int id});

  /// Get all user reads
  Future<List<BookModel>> getUserReads({required bool isFinished});

  /// Create user read
  Future<void> createUserRead({required int bookId});

  /// Update user read
  Future<void> updateUserRead({
    required int bookId,
    required int currentPage,
  });

  /// Delete user read
  Future<void> deleteUserRead({required int bookId});
}

class BookDataSourceImpl implements BookDataSource {
  final http.Client client;

  BookDataSourceImpl({required this.client});

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
      exception(e);
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
      exception(e);
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
      exception(e);
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
      exception(e);
    }
  }

  @override
  Future<List<BookModel>> getBooks({
    String query = '',
    int? offset,
    int? limit,
    int? categoryId,
  }) async {
    try {
      final queryParams =
          'term=$query&offset=${offset ?? ''}&limit=${limit ?? ''}&categoryId=${categoryId ?? ''}';

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
      exception(e);
    }
  }

  @override
  Future<BookModel> getBookDetail({required int id}) async {
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
        return BookModel.fromMap(result.data);
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> createBook({
    required BookPostModel book,
    required String bookPath,
    required String imagePath,
  }) async {
    try {
      final bookFile = await http.MultipartFile.fromPath(
        'files',
        bookPath,
        filename: const Uuid().v4() + p.extension(bookPath),
      );

      final imageFile = await http.MultipartFile.fromPath(
        'files',
        imagePath,
        filename: const Uuid().v4() + p.extension(imagePath),
      );

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfigs.baseUrl}/books'),
      )
        ..fields.addAll(book.toMap())
        ..files.addAll([bookFile, imageFile])
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${CredentialSaver.accessToken}';

      final streamedResponse = await client.send(request);
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
  Future<void> editBookFile({
    required int id,
    required String path,
    required BookFileType type,
  }) async {
    try {
      final file = await http.MultipartFile.fromPath(
        'file',
        path,
        filename: const Uuid().v4() + p.extension(path),
      );

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConfigs.baseUrl}/books/${type.name}/$id'),
      )
        ..files.add(file)
        ..headers[HttpHeaders.authorizationHeader] =
            'Bearer ${CredentialSaver.accessToken}';

      final streamedResponse = await client.send(request);
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
  Future<void> editBook({required BookModel book}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/books/${book.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({
          'title': book.title,
          'synopsis': book.synopsis,
          'writer': book.writer,
          'publisher': book.publisher,
          'pageAmt': book.pageAmt,
          'categoryId': book.category?.id,
          'releaseDate':
              '${book.releaseDate?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'")}',
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
      exception(e);
    }
  }

  @override
  Future<List<BookSavedModel>> getSavedBooks({required int userId}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfigs.baseUrl}/saved-books?userId=$userId'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
      );

      final result = DataResponse.fromJson(jsonDecode(response.body));

      if (result.code == 200) {
        final data = result.data as List;

        return data.map((e) => BookSavedModel.fromMap(e)).toList();
      } else {
        throw ServerException('${result.message}');
      }
    } catch (e) {
      exception(e);
    }
  }

  @override
  Future<void> saveBook({required int bookId}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/saved-books'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({'bookId': bookId}),
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
  Future<void> unsaveBook({required int id}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/saved-books/$id'),
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
  Future<List<BookModel>> getUserReads({required bool isFinished}) async {
    try {
      final response = await client.get(
        Uri.parse(
          '${ApiConfigs.baseUrl}/auth/continue-reading?isFinished=$isFinished',
        ),
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
      exception(e);
    }
  }

  @override
  Future<void> createUserRead({required int bookId}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfigs.baseUrl}/user-reads'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({'bookId': bookId}),
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
  Future<void> updateUserRead({
    required int bookId,
    required int currentPage,
  }) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConfigs.baseUrl}/user-reads?bookId=$bookId'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${CredentialSaver.accessToken}'
        },
        body: jsonEncode({'currentPage': currentPage}),
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
  Future<void> deleteUserRead({required int bookId}) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConfigs.baseUrl}/user-reads?bookId=$bookId'),
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
