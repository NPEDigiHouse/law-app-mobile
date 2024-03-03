// Package imports:
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/book_data_source.dart';
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';

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
}
