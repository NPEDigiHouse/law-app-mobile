import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';

class BookModel extends Equatable {
  final int? id;
  final String? title;
  final String? synopsis;
  final String? writer;
  final String? publisher;
  final String? releaseDate;
  final int? pageAmt;
  final String? coverImage;
  final BookCategoryModel? category;

  const BookModel({
    this.id,
    this.title,
    this.synopsis,
    this.writer,
    this.publisher,
    this.releaseDate,
    this.pageAmt,
    this.coverImage,
    this.category,
  });

  BookModel copyWith({
    int? id,
    String? title,
    String? synopsis,
    String? writer,
    String? publisher,
    String? releaseDate,
    int? pageAmt,
    String? coverImage,
    BookCategoryModel? category,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      synopsis: synopsis ?? this.synopsis,
      writer: writer ?? this.writer,
      publisher: publisher ?? this.publisher,
      releaseDate: releaseDate ?? this.releaseDate,
      pageAmt: pageAmt ?? this.pageAmt,
      coverImage: coverImage ?? this.coverImage,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'writer': writer,
      'publisher': publisher,
      'releaseDate': releaseDate,
      'pageAmt': pageAmt,
      'coverImage': coverImage,
      'category': category?.toMap(),
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      synopsis: map['synopsis'] as String?,
      writer: map['writer'] as String?,
      publisher: map['publisher'] as String?,
      releaseDate: map['releaseDate'] as String?,
      pageAmt: map['pageAmt'] as int?,
      coverImage: map['coverImage'] as String?,
      category: map['category'] != null
          ? BookCategoryModel.fromMap(map['category'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(String source) =>
      BookModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      synopsis,
      writer,
      publisher,
      releaseDate,
      pageAmt,
      coverImage,
      category,
    ];
  }
}
