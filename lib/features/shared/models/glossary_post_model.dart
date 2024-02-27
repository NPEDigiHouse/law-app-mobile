// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class GlossaryPostModel extends Equatable {
  final String title;
  final String description;

  const GlossaryPostModel({
    required this.title,
    required this.description,
  });

  GlossaryPostModel copyWith({
    String? title,
    String? description,
  }) {
    return GlossaryPostModel(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, description];
}
