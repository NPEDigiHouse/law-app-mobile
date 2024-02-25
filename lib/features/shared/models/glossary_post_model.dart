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

  factory GlossaryPostModel.fromMap(Map<String, dynamic> map) {
    return GlossaryPostModel(
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlossaryPostModel.fromJson(String source) =>
      GlossaryPostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, description];
}
