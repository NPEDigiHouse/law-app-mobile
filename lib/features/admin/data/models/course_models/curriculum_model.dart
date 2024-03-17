// Package imports:
import 'package:equatable/equatable.dart';

class CurriculumModel extends Equatable {
  final int? id;
  final String? title;
  final int? curriculumDuration;

  const CurriculumModel({
    this.id,
    this.title,
    this.curriculumDuration,
  });

  CurriculumModel copyWith({
    int? id,
    String? title,
    int? curriculumDuration,
  }) {
    return CurriculumModel(
      id: id ?? this.id,
      title: title ?? this.title,
      curriculumDuration: curriculumDuration ?? this.curriculumDuration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'curriculumDuration': curriculumDuration,
    };
  }

  factory CurriculumModel.fromMap(Map<String, dynamic> map) {
    return CurriculumModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      curriculumDuration: map['curriculumDuration'] as int?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title, curriculumDuration];
}
