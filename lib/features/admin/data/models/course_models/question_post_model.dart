// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class QuestionPostModel extends Equatable {
  final String title;
  final int correctOptionId;
  final int quizId;

  const QuestionPostModel({
    required this.title,
    required this.correctOptionId,
    required this.quizId,
  });

  QuestionPostModel copyWith({
    String? title,
    int? correctOptionId,
    int? quizId,
  }) {
    return QuestionPostModel(
      title: title ?? this.title,
      correctOptionId: correctOptionId ?? this.correctOptionId,
      quizId: quizId ?? this.quizId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'correctOptionId': correctOptionId,
      'quizId': quizId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, correctOptionId, quizId];
}
