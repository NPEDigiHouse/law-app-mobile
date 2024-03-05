// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class BookPostModel extends Equatable {
  final String title;
  final String synopsis;
  final String writer;
  final String publisher;
  final String releaseDate;
  final int pageAmt;
  final int categoryId;

  const BookPostModel({
    required this.title,
    required this.synopsis,
    required this.writer,
    required this.publisher,
    required this.releaseDate,
    required this.pageAmt,
    required this.categoryId,
  });

  BookPostModel copyWith({
    String? title,
    String? synopsis,
    String? writer,
    String? publisher,
    String? releaseDate,
    int? pageAmt,
    int? categoryId,
  }) {
    return BookPostModel(
      title: title ?? this.title,
      synopsis: synopsis ?? this.synopsis,
      writer: writer ?? this.writer,
      publisher: publisher ?? this.publisher,
      releaseDate: releaseDate ?? this.releaseDate,
      pageAmt: pageAmt ?? this.pageAmt,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'synopsis': synopsis,
      'writer': writer,
      'publisher': publisher,
      'releaseDate': releaseDate,
      'pageAmt': pageAmt,
      'categoryId': categoryId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      title,
      synopsis,
      writer,
      publisher,
      releaseDate,
      pageAmt,
      categoryId,
    ];
  }
}
