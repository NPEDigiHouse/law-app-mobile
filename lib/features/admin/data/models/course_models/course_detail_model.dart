// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/curriculum_model.dart';

class CourseDetailModel extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final String? coverImg;
  final List<CurriculumModel>? curriculums;

  const CourseDetailModel({
    this.id,
    this.title,
    this.description,
    this.coverImg,
    this.curriculums,
  });

  CourseDetailModel copyWith({
    int? id,
    String? title,
    String? description,
    String? coverImg,
    DateTime? createdAt,
    List<CurriculumModel>? curriculums,
  }) {
    return CourseDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImg: coverImg ?? this.coverImg,
      curriculums: curriculums ?? this.curriculums,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'coverImg': coverImg,
      'curriculums': curriculums?.map((e) => e.toMap()).toList(),
    };
  }

  factory CourseDetailModel.fromMap(Map<String, dynamic> map) {
    return CourseDetailModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      coverImg: map['coverImg'] as String?,
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
  List<Object?> get props => [id, title, description, coverImg, curriculums];
}
