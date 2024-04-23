// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';

class QuizResultModel extends Equatable {
  final int? id;
  final int? correctAnswersAmt;
  final int? incorrectAnswersAmt;
  final DateTime? createdAt;

  const QuizResultModel({
    this.id,
    this.correctAnswersAmt,
    this.incorrectAnswersAmt,
    this.createdAt,
  });

  QuizResultModel copyWith({
    int? id,
    int? correctAnswersAmt,
    int? incorrectAnswersAmt,
    DateTime? createdAt,
  }) {
    return QuizResultModel(
      id: id ?? this.id,
      correctAnswersAmt: correctAnswersAmt ?? this.correctAnswersAmt,
      incorrectAnswersAmt: incorrectAnswersAmt ?? this.incorrectAnswersAmt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'correctAnswersAmt': correctAnswersAmt,
      'incorrectAnswersAmt': incorrectAnswersAmt,
      'createdAt': createdAt?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
    };
  }

  factory QuizResultModel.fromMap(Map<String, dynamic> map) {
    return QuizResultModel(
      id: map['id'] as int?,
      correctAnswersAmt: map['correctAnswersAmt'] as int?,
      incorrectAnswersAmt: map['incorrectAnswersAmt'] as int?,
      createdAt: DateTime.tryParse((map['createdAt'] as String?) ?? ''),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        correctAnswersAmt,
        incorrectAnswersAmt,
        createdAt,
      ];
}
