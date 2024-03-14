// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class CoursePostModel extends Equatable {
  final String title;
  final String description;
  final String cover;

  const CoursePostModel({
    required this.title,
    required this.description,
    required this.cover,
  });

  CoursePostModel copyWith({
    String? title,
    String? description,
    String? cover,
  }) {
    return CoursePostModel(
      title: title ?? this.title,
      description: description ?? this.description,
      cover: cover ?? this.cover,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'cover': cover,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, description, cover];
}
