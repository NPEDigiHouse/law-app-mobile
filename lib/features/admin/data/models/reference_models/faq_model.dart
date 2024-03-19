// Package imports:
import 'package:equatable/equatable.dart';

class FAQModel extends Equatable {
  final int? id;
  final String? question;
  final String? answer;

  const FAQModel({
    this.id,
    this.question,
    this.answer,
  });

  FAQModel copyWith({
    int? id,
    String? question,
    String? answer,
  }) {
    return FAQModel(
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

  factory FAQModel.fromMap(Map<String, dynamic> map) {
    return FAQModel(
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
