// Package imports:
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/enums/book_file_type.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/book_data_source.dart';
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_post_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_saved_model.dart';

abstract class BookRepository {
  /// Get book categories
  Future<Either<Failure, List<BookCategoryModel>>> getBookCategories();

  /// Create book categories
  Future<Either<Failure, void>> createBookCategory({required String name});

  /// Edit book categories
  Future<Either<Failure, void>> editBookCategory(
      {required BookCategoryModel category});

  /// Delete book categories
  Future<Either<Failure, void>> deleteBookCategory({required int id});

  // Get all books
  Future<Either<Failure, List<BookModel>>> getBooks({
    String query = '',
    int? offset,
    int? limit,
    int? categoryId,
  });

  /// Get book detail
  Future<Either<Failure, BookDetailModel>> getBookDetail({required int id});

  /// Create book
  Future<Either<Failure, void>> createBook({
    required BookPostModel book,
    required String bookPath,
    required String imagePath,
  });

  /// Edit book file
  Future<Either<Failure, void>> editBookFile({
    required int id,
    required String path,
    required BookFileType type,
  });

  /// Edit book
  Future<Either<Failure, void>> editBook({required BookDetailModel book});

  /// Delete book
  Future<Either<Failure, void>> deleteBook({required int id});

  /// Get all saved books
  Future<Either<Failure, List<BookSavedModel>>> getSavedBooks(
      {required int userId});

  /// Save book
  Future<Either<Failure, void>> saveBook({
    required int userId,
    required int bookId,
  });

  /// Unsave book
  Future<Either<Failure, void>> unsaveBook({required int id});
}

class BookRepositoryImpl implements BookRepository {
  final BookDataSource bookDataSource;
  final NetworkInfo networkInfo;

  BookRepositoryImpl({
    required this.bookDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BookCategoryModel>>> getBookCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.getBookCategories();

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createBookCategory(
      {required String name}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.createBookCategory(name: name);

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kCategoryAlreadyExist:
            return const Left(
              ServerFailure('Telah terdapat kategori dengan nama yang sama'),
            );
          default:
            return Left(ServerFailure(e.message));
        }
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editBookCategory(
      {required BookCategoryModel category}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await bookDataSource.editBookCategory(category: category);

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kCategoryAlreadyExist:
            return const Left(
              ServerFailure('Telah terdapat kategori dengan nama yang sama'),
            );
          default:
            return Left(ServerFailure(e.message));
        }
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBookCategory({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.deleteBookCategory(id: id);

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<BookModel>>> getBooks({
    String query = '',
    int? offset,
    int? limit,
    int? categoryId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.getBooks(
          query: query,
          offset: offset,
          limit: limit,
          categoryId: categoryId,
        );

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, BookDetailModel>> getBookDetail(
      {required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.getBookDetail(id: id);

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createBook({
    required BookPostModel book,
    required String bookPath,
    required String imagePath,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.createBook(
          book: book,
          bookPath: bookPath,
          imagePath: imagePath,
        );

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editBookFile({
    required int id,
    required String path,
    required BookFileType type,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.editBookFile(
          id: id,
          path: path,
          type: type,
        );

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editBook(
      {required BookDetailModel book}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.editBook(book: book);

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBook({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.deleteBook(id: id);

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<BookSavedModel>>> getSavedBooks(
      {required int userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.getSavedBooks(userId: userId);

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> saveBook({
    required int userId,
    required int bookId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.saveBook(
          userId: userId,
          bookId: bookId,
        );

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> unsaveBook({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.unsaveBook(id: id);

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ClientException catch (e) {
        return Left(ClientFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
