// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:law_app/features/admin/data/repositories/course_repository.dart';
import 'package:law_app/features/shared/providers/course_providers/datasources_provider/course_data_source_provider.dart';
import 'package:law_app/features/shared/providers/generated_providers/network_info_provider.dart';

part 'course_repository_provider.g.dart';

@riverpod
CourseRepository courseRepository(CourseRepositoryRef ref) {
  return CourseRepositoryImpl(
    courseDataSource: ref.watch(courseDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
