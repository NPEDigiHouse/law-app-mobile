// Package imports:
import 'package:equatable/equatable.dart';

class FaqModel extends Equatable {
  final int? id;
  final String? question;
  final String? answer;

  const FaqModel({
    this.id,
    this.question,
    this.answer,
  });

  FaqModel copyWith({
    int? id,
    String? question,
    String? answer,
  }) {
    return FaqModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'answer': answer,
    };
  }

  factory FaqModel.fromMap(Map<String, dynamic> map) {
    return FaqModel(
      id: map['id'] as int?,
      question: map['question'] as String?,
      answer: map['answer'] as String?,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, question, answer];
}
