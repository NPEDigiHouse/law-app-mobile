// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class CurriculumPostModel extends Equatable {
  final String title;
  final int courseId;

  const CurriculumPostModel({
    required this.title,
    required this.courseId,
  });

  CurriculumPostModel copyWith({
    String? title,
    int? courseId,
  }) {
    return CurriculumPostModel(
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'courseId': courseId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, courseId];
}
