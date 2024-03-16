// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class QuizPostModel extends Equatable {
  final String title;
  final String description;
  final int duration;
  final int curriculumId;

  const QuizPostModel({
    required this.title,
    required this.description,
    required this.duration,
    required this.curriculumId,
  });

  QuizPostModel copyWith({
    String? title,
    String? description,
    int? duration,
    int? curriculumId,
  }) {
    return QuizPostModel(
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      curriculumId: curriculumId ?? this.curriculumId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'duration': duration,
      'curriculumId': curriculumId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, description, duration, curriculumId];
}
