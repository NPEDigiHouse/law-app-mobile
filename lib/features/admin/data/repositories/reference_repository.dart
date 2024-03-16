// Package imports:
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/reference_data_source.dart';
import 'package:law_app/features/admin/data/models/contact_us_models/contact_us_model.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_category_model.dart';
import 'package:law_app/features/admin/data/models/faq_models/faq_model.dart';

abstract class ReferenceRepository {
  /// Get discussion categories
  Future<Either<Failure, List<DiscussionCategoryModel>>>
      getDiscussionCategories();

  /// Create discussion category
  Future<Either<Failure, void>> createDiscussionCategory(
      {required String name});

  /// Edit discussion category
  Future<Either<Failure, void>> editDiscussionCategory(
      {required DiscussionCategoryModel category});

  /// Delete discussion category
  Future<Either<Failure, void>> deleteDiscussionCategory({required int id});

  /// Get faq
  Future<Either<Failure, List<FaqModel>>> getFaq();

  /// Create faq
  Future<Either<Failure, void>> createFaq(
      {required String question, required String answer});

  /// Edit faq
  Future<Either<Failure, void>> editFaq({required FaqModel faq});

  /// Delete faq
  Future<Either<Failure, void>> deleteFaq({required int id});

  Future<Either<Failure, ContactUsModel>> getContactUs();

  Future<Either<Failure, void>> editContactUs(
      {required ContactUsModel contact});
}

class ReferenceRepositoryImpl implements ReferenceRepository {
  final ReferenceDataSource referenceDataSource;
  final NetworkInfo networkInfo;

  ReferenceRepositoryImpl({
    required this.referenceDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DiscussionCategoryModel>>>
      getDiscussionCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.getDiscussionCategories();

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
  Future<Either<Failure, void>> createDiscussionCategory(
      {required String name}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await referenceDataSource.createDiscussionCategory(name: name);

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
  Future<Either<Failure, void>> editDiscussionCategory(
      {required DiscussionCategoryModel category}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.editDiscussionCategory(
            category: category);

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
  Future<Either<Failure, void>> deleteDiscussionCategory(
      {required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await referenceDataSource.deleteDiscussionCategory(id: id);

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
  Future<Either<Failure, List<FaqModel>>> getFaq() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.getFaq();

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
  Future<Either<Failure, void>> createFaq(
      {required String question, required String answer}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.createFaq(
            question: question, answer: answer);

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kCategoryAlreadyExist:
            return const Left(
              ServerFailure(
                  'Telah terdapat pertanyaan dengan jawaban yang sama'),
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
  Future<Either<Failure, void>> editFaq({required FaqModel faq}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.editFaq(faq: faq);

        return Right(result);
      } on ServerException catch (e) {
        switch (e.message) {
          case kCategoryAlreadyExist:
            return const Left(
              ServerFailure(
                  'Telah terdapat pertanyaan dengan jawaban yang sama'),
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
  Future<Either<Failure, void>> deleteFaq({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.deleteFaq(id: id);

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
  Future<Either<Failure, ContactUsModel>> getContactUs() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.getContactUs();

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
  Future<Either<Failure, void>> editContactUs(
      {required ContactUsModel contact}) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await referenceDataSource.editContactUs(contact: contact);

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
