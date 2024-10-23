// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:law_app/core/connections/network_info.dart';
import 'package:law_app/core/errors/failures.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/features/admin/data/datasources/reference_data_source.dart';
import 'package:law_app/features/admin/data/models/reference_models/contact_us_model.dart';
import 'package:law_app/features/admin/data/models/reference_models/discussion_category_model.dart';
import 'package:law_app/features/admin/data/models/reference_models/faq_model.dart';

abstract class ReferenceRepository {
  /// Get discussion categories
  Future<Either<Failure, List<DiscussionCategoryModel>>> getDiscussionCategories();

  /// Create discussion category
  Future<Either<Failure, void>> createDiscussionCategory({required String name});

  /// Edit discussion category
  Future<Either<Failure, void>> editDiscussionCategory({required DiscussionCategoryModel category});

  /// Delete discussion category
  Future<Either<Failure, void>> deleteDiscussionCategory({required int id});

  /// Get FAQs
  Future<Either<Failure, List<FAQModel>>> getFAQs();

  /// Create FAQ
  Future<Either<Failure, void>> createFAQ({
    required String question,
    required String answer,
  });

  /// Edit FAQ
  Future<Either<Failure, void>> editFAQ({required FAQModel faq});

  /// Delete FAQ
  Future<Either<Failure, void>> deleteFAQ({required int id});

  /// Get contact us
  Future<Either<Failure, ContactUsModel?>> getContactUs();

  /// Edit contact us
  Future<Either<Failure, void>> editContactUs({required ContactUsModel contact});
}

class ReferenceRepositoryImpl implements ReferenceRepository {
  final ReferenceDataSource referenceDataSource;
  final NetworkInfo networkInfo;

  ReferenceRepositoryImpl({
    required this.referenceDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DiscussionCategoryModel>>> getDiscussionCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.getDiscussionCategories();

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createDiscussionCategory({required String name}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.createDiscussionCategory(name: name);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editDiscussionCategory({required DiscussionCategoryModel category}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.editDiscussionCategory(category: category);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDiscussionCategory({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.deleteDiscussionCategory(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<FAQModel>>> getFAQs() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.getFAQs();

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createFAQ({
    required String question,
    required String answer,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.createFAQ(
          question: question,
          answer: answer,
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
  Future<Either<Failure, void>> editFAQ({required FAQModel faq}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.editFAQ(faq: faq);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFAQ({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.deleteFAQ(id: id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, ContactUsModel?>> getContactUs() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.getContactUs();

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editContactUs({required ContactUsModel contact}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await referenceDataSource.editContactUs(contact: contact);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
