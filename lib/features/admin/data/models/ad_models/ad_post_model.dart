// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class AdPostModel extends Equatable {
  final String title;
  final String content;
  final String file;

  const AdPostModel({
    required this.title,
    required this.content,
    required this.file,
  });

  AdPostModel copyWith({
    String? title,
    String? content,
    String? file,
  }) {
    return AdPostModel(
      title: title ?? this.title,
      content: content ?? this.content,
      file: file ?? this.file,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': content,
      'file': file,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [title, content, file];
}
