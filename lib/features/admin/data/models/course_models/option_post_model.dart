// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class OptionPostModel extends Equatable {
  final String title;
  final int quizQuestionId;

  const OptionPostModel({
    required this.title,
    required this.quizQuestionId,
  });

  OptionPostModel copyWith({
    String? title,
    int? quizQuestionId,
  }) {
    return OptionPostModel(
      title: title ?? this.title,
      quizQuestionId: quizQuestionId ?? this.quizQuestionId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'quizQuestionId': quizQuestionId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, quizQuestionId];
}
