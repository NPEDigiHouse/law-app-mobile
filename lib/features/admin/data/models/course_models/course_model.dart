// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/curriculum_model.dart';

class CourseModel extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final String? coverImg;
  final int? courseDuration;
  final int? rating;
  final int? enrolledMembers;
  final String? status;
  final List<CurriculumModel>? curriculums;

  const CourseModel({
    this.id,
    this.title,
    this.description,
    this.coverImg,
    this.courseDuration,
    this.rating,
    this.enrolledMembers,
    this.status,
    this.curriculums,
  });

  CourseModel copyWith({
    int? id,
    String? title,
    String? description,
    String? coverImg,
    int? courseDuration,
    int? rating,
    int? enrolledMembers,
    String? status,
    List<CurriculumModel>? curriculums,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImg: coverImg ?? this.coverImg,
      courseDuration: courseDuration ?? this.courseDuration,
      rating: rating ?? this.rating,
      enrolledMembers: enrolledMembers ?? this.enrolledMembers,
      status: status ?? this.status,
      curriculums: curriculums ?? this.curriculums,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'coverImg': coverImg,
      'courseDuration': courseDuration,
      'curriculums': curriculums?.map((e) => e.toMap()).toList(),
      'rating': rating,
      'status': status,
      'enrolledMembers': enrolledMembers,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      coverImg: map['coverImg'] as String?,
      courseDuration: map['courseDuration'] as int?,
      rating: map['rating'] as int?,
      enrolledMembers: map['enrolledMembers'] as int?,
      status: map['status'] as String?,
      curriculums: map['curriculums'] != null
          ? List<CurriculumModel>.from(
              (map['curriculums'] as List).map(
                (e) => CurriculumModel.fromMap(e as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        coverImg,
        courseDuration,
        rating,
        enrolledMembers,
        status,
        curriculums,
      ];
}
