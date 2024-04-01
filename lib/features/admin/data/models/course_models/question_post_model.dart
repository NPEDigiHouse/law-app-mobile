// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class QuestionPostModel extends Equatable {
  final String title;
  final int quizId;

  const QuestionPostModel({
    required this.title,
    required this.quizId,
  });

  QuestionPostModel copyWith({
    String? title,
    int? correctOptionId,
    int? quizId,
  }) {
    return QuestionPostModel(
      title: title ?? this.title,
      quizId: quizId ?? this.quizId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'quizId': quizId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, quizId];
}
