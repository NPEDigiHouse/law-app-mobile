// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class ArticlePostModel extends Equatable {
  final String title;
  final String material;
  final int duration;
  final int curriculumId;

  const ArticlePostModel({
    required this.title,
    required this.material,
    required this.duration,
    required this.curriculumId,
  });

  ArticlePostModel copyWith({
    String? title,
    String? material,
    int? duration,
    int? curriculumId,
  }) {
    return ArticlePostModel(
      title: title ?? this.title,
      material: material ?? this.material,
      duration: duration ?? this.duration,
      curriculumId: curriculumId ?? this.curriculumId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'material': material,
      'duration': duration,
      'curriculumId': curriculumId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, material, duration, curriculumId];
}
