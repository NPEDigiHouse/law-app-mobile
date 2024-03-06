// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';

class BookPostModel extends Equatable {
  final String title;
  final String synopsis;
  final String writer;
  final String publisher;
  final String pageAmt;
  final String categoryId;
  final DateTime releaseDate;

  const BookPostModel({
    required this.title,
    required this.synopsis,
    required this.writer,
    required this.publisher,
    required this.pageAmt,
    required this.categoryId,
    required this.releaseDate,
  });

  BookPostModel copyWith({
    String? title,
    String? synopsis,
    String? writer,
    String? publisher,
    String? pageAmt,
    String? categoryId,
    DateTime? releaseDate,
  }) {
    return BookPostModel(
      title: title ?? this.title,
      synopsis: synopsis ?? this.synopsis,
      writer: writer ?? this.writer,
      publisher: publisher ?? this.publisher,
      pageAmt: pageAmt ?? this.pageAmt,
      categoryId: categoryId ?? this.categoryId,
      releaseDate: releaseDate ?? this.releaseDate,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'title': title,
      'synopsis': synopsis,
      'writer': writer,
      'publisher': publisher,
      'pageAmt': pageAmt,
      'categoryId': categoryId,
      'releaseDate':
          releaseDate.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
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
      pageAmt,
      categoryId,
      releaseDate,
    ];
  }
}
