// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/features/admin/data/models/course_models/quiz_result_model.dart';

class QuizModel extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final int? duration;
  final int? totalQuestions;
  final QuizResultModel? answerHistory;

  const QuizModel({
    this.id,
    this.title,
    this.description,
    this.duration,
    this.totalQuestions,
    this.answerHistory,
  });

  QuizModel copyWith({
    int? id,
    String? title,
    String? description,
    int? duration,
    int? totalQuestions,
    QuizResultModel? answerHistory,
  }) {
    return QuizModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      answerHistory: answerHistory ?? this.answerHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'totalQuestions': totalQuestions,
      'answerHistory': answerHistory?.toMap(),
    };
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      duration: map['duration'] as int?,
      totalQuestions: map['totalQuestions'] as int?,
      answerHistory: map['answerHistory'] != null
          ? QuizResultModel.fromMap(
              map['answerHistory'] as Map<String, dynamic>,
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
        description,
        duration,
        totalQuestions,
        answerHistory,
      ];
}
