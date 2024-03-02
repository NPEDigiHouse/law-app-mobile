// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class DiscussionPostModel extends Equatable {
  final String title;
  final String description;
  final int categoryId;

  const DiscussionPostModel({
    required this.title,
    required this.description,
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
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'categoryId': categoryId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, description, categoryId];
}
