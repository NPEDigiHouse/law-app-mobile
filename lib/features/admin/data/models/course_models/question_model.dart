// Package imports:
import 'package:equatable/equatable.dart';

class QuestionModel extends Equatable {
  final int? id;
  final String? title;
  final int? correctOptionId;

  const QuestionModel({
    this.id,
    this.title,
    this.correctOptionId,
  });

  QuestionModel copyWith({
    int? id,
    String? title,
    int? correctOptionId,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      correctOptionId: correctOptionId ?? this.correctOptionId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'correctOptionId': correctOptionId,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      correctOptionId: map['correctOptionId'] as int?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title, correctOptionId];
}
