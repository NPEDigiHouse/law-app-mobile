// Package imports:
import 'package:equatable/equatable.dart';

class CurriculumModel extends Equatable {
  final int? id;
  final String? title;

  const CurriculumModel({
    this.id,
    this.title,
  });

  CurriculumModel copyWith({
    int? id,
    String? title,
  }) {
    return CurriculumModel(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
    };
  }

  factory CurriculumModel.fromMap(Map<String, dynamic> map) {
    return CurriculumModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title];
}
