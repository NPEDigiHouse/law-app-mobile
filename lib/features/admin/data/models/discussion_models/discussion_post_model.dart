// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class DiscussionPostModel extends Equatable {
  final String title;
  final String description;
  final int askerId;
  final int categoryId;

  const DiscussionPostModel({
    required this.title,
    required this.description,
    required this.askerId,
    required this.categoryId,
  });

  DiscussionPostModel copyWith({
    String? title,
    String? description,
    int? askerId,
    int? categoryId,
  }) {
    return DiscussionPostModel(
      title: title ?? this.title,
      description: description ?? this.description,
      askerId: askerId ?? this.askerId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'askerId': askerId,
      'categoryId': categoryId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        title,
        description,
        askerId,
        categoryId,
      ];
}
