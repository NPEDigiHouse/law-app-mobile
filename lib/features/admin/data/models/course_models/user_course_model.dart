// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/course_model.dart';

class UserCourseModel extends Equatable {
  final int? id;
  final String? status;
  final CourseModel? course;
  final int? currentCurriculumSequence;
  final int? currentMaterialSequence;

  const UserCourseModel({
    this.id,
    this.status,
    this.course,
    this.currentCurriculumSequence,
    this.currentMaterialSequence,
  });

  UserCourseModel copyWith({
    int? id,
    String? status,
    CourseModel? course,
    int? currentCurriculumSequence,
    int? currentMaterialSequence,
  }) {
    return UserCourseModel(
      id: id ?? this.id,
      status: status ?? this.status,
      course: course ?? this.course,
      currentCurriculumSequence: currentCurriculumSequence ?? this.currentCurriculumSequence,
      currentMaterialSequence: currentMaterialSequence ?? this.currentMaterialSequence,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'course': course?.toMap(),
      'currentCurriculumSequence': currentCurriculumSequence,
      'currentMaterialSequence': currentMaterialSequence,
    };
  }

  factory UserCourseModel.fromMap(Map<String, dynamic> map) {
    return UserCourseModel(
      id: map['id'] as int?,
      status: map['status'] as String?,
      course:
          map['course'] != null ? CourseModel.fromMap(map['course'] as Map<String, dynamic>) : null,
      currentCurriculumSequence: map['currentCurriculumSequence'] as int?,
      currentMaterialSequence: map['currentMaterialSequence'] as int?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        status,
        course,
        currentCurriculumSequence,
        currentMaterialSequence,
      ];
}
