// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/material_model.dart';

class CurriculumModel extends Equatable {
  final int? id;
  final String? title;
  final int? curriculumDuration;
  final int? sequenceNumber;
  final List<MaterialModel>? articles;
  final List<MaterialModel>? quizzes;

  const CurriculumModel({
    this.id,
    this.title,
    this.curriculumDuration,
    this.sequenceNumber,
    this.articles,
    this.quizzes,
  });

  CurriculumModel copyWith({
    int? id,
    String? title,
    int? curriculumDuration,
    int? sequenceNumber,
    List<MaterialModel>? articles,
    List<MaterialModel>? quizzes,
  }) {
    return CurriculumModel(
      id: id ?? this.id,
      title: title ?? this.title,
      curriculumDuration: curriculumDuration ?? this.curriculumDuration,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      articles: articles ?? this.articles,
      quizzes: quizzes ?? this.quizzes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'curriculumDuration': curriculumDuration,
      'sequenceNumber': sequenceNumber,
      'articles': articles?.map((e) => e.toMap()).toList(),
      'quizzes': quizzes?.map((e) => e.toMap()).toList(),
    };
  }

  factory CurriculumModel.fromMap(Map<String, dynamic> map) {
    return CurriculumModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      curriculumDuration: map['curriculumDuration'] as int?,
      sequenceNumber: map['sequenceNumber'] as int?,
      articles: map['articles'] != null
          ? List<MaterialModel>.from(
              (map['articles'] as List).map(
                (e) => MaterialModel.fromMap(e as Map<String, dynamic>),
              ),
            )
          : null,
      quizzes: map['quizzes'] != null
          ? List<MaterialModel>.from(
              (map['quizzes'] as List).map(
                (e) => MaterialModel.fromMap(e as Map<String, dynamic>),
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
        curriculumDuration,
        sequenceNumber,
        articles,
        quizzes,
      ];
}
