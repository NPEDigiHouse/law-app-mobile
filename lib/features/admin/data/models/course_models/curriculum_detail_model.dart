// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/material_model.dart';

class CurriculumDetailModel extends Equatable {
  final int? id;
  final String? title;
  final int? curriculumDuration;
  final List<MaterialModel>? articles;
  final List<MaterialModel>? quizes;

  const CurriculumDetailModel({
    this.id,
    this.title,
    this.curriculumDuration,
    this.articles,
    this.quizes,
  });

  CurriculumDetailModel copyWith({
    int? id,
    String? title,
    int? curriculumDuration,
    List<MaterialModel>? articles,
    List<MaterialModel>? quizes,
  }) {
    return CurriculumDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      curriculumDuration: curriculumDuration ?? this.curriculumDuration,
      articles: articles ?? this.articles,
      quizes: quizes ?? this.quizes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'curriculumDuration': curriculumDuration,
      'articles': articles?.map((e) => e.toMap()).toList(),
      'quizes': quizes?.map((e) => e.toMap()).toList(),
    };
  }

  factory CurriculumDetailModel.fromMap(Map<String, dynamic> map) {
    return CurriculumDetailModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      curriculumDuration: map['curriculumDuration'] as int?,
      articles: map['articles'] != null
          ? List<MaterialModel>.from(
              (map['articles'] as List).map(
                (e) => MaterialModel.fromMap(e as Map<String, dynamic>),
              ),
            )
          : null,
      quizes: map['quizes'] != null
          ? List<MaterialModel>.from(
              (map['quizes'] as List).map(
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
        articles,
        quizes,
      ];
}
