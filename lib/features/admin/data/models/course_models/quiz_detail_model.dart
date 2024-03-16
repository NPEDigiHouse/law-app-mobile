// Package imports:
import 'package:equatable/equatable.dart';

class QuizDetailModel extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final int? duration;

  const QuizDetailModel({
    this.id,
    this.title,
    this.description,
    this.duration,
  });

  QuizDetailModel copyWith({
    int? id,
    String? title,
    String? description,
    int? duration,
  }) {
    return QuizDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
    };
  }

  factory QuizDetailModel.fromMap(Map<String, dynamic> map) {
    return QuizDetailModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      duration: map['duration'] as int?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title, description, duration];
}
