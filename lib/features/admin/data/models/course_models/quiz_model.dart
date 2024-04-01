// Package imports:
import 'package:equatable/equatable.dart';

class QuizModel extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final int? duration;
  final int? totalQuestions;

  const QuizModel({
    this.id,
    this.title,
    this.description,
    this.duration,
    this.totalQuestions,
  });

  QuizModel copyWith({
    int? id,
    String? title,
    String? description,
    int? duration,
    int? totalQuestions,
  }) {
    return QuizModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'totalQuestions': totalQuestions,
    };
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      duration: map['duration'] as int?,
      totalQuestions: map['totalQuestions'] as int?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title, description, duration, totalQuestions];
}
