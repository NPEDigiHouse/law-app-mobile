// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/enums/book_file_type.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/book_data_source.dart';
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_post_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_saved_model.dart';

abstract class BookRepository {
  /// Get book categories
  Future<Either<Failure, List<BookCategoryModel>>> getBookCategories();

  /// Create book category
  Future<Either<Failure, void>> createBookCategory({required String name});

  /// Edit book category
  Future<Either<Failure, void>> editBookCategory({required BookCategoryModel category});

  /// Delete book category
  Future<Either<Failure, void>> deleteBookCategory({required int id});

  // Get all books
  Future<Either<Failure, List<BookModel>>> getBooks({
    String query = '',
    int? offset,
    int? limit,
    int? categoryId,
  });

  /// Get book detail
  Future<Either<Failure, BookModel>> getBookDetail({required int id});

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
  Future<Either<Failure, void>> editBook({required BookModel book});

  /// Delete book
  Future<Either<Failure, void>> deleteBook({required int id});

  /// Get all saved books
  Future<Either<Failure, List<BookSavedModel>>> getSavedBooks({required int userId});

  /// Save book
  Future<Either<Failure, void>> saveBook({required int bookId});

  /// Unsave book
  Future<Either<Failure, void>> unsaveBook({required int id});

  /// Get all user reads
  Future<Either<Failure, List<BookModel>>> getUserReads({required bool isFinished});

  /// Create user read
  Future<Either<Failure, void>> createUserRead({required int bookId});

  /// Update user read
  Future<Either<Failure, void>> updateUserRead({
    required int bookId,
    required int currentPage,
  });

  /// Delete user read
  Future<Either<Failure, void>> deleteUserRead({required int bookId});
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createBookCategory({required String name}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.createBookCategory(name: name);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editBookCategory({required BookCategoryModel category}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.editBookCategory(category: category);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, BookModel>> getBookDetail({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.getBookDetail(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editBook({required BookModel book}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.editBook(book: book);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<BookSavedModel>>> getSavedBooks({required int userId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.getSavedBooks(userId: userId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> saveBook({required int bookId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.saveBook(bookId: bookId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
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
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<BookModel>>> getUserReads({required bool isFinished}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.getUserReads(isFinished: isFinished);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createUserRead({required int bookId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.createUserRead(bookId: bookId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRead({
    required int bookId,
    required int currentPage,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.updateUserRead(
          bookId: bookId,
          currentPage: currentPage,
        );

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserRead({required int bookId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await bookDataSource.deleteUserRead(bookId: bookId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
