// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';

class BookModel extends Equatable {
  final int? id;
  final String? title;
  final String? synopsis;
  final String? writer;
  final String? publisher;
  final DateTime? releaseDate;
  final int? pageAmt;
  final String? coverImage;
  final String? bookUrl;
  final BookCategoryModel? category;
  final int? currentPage;

  const BookModel({
    this.id,
    this.title,
    this.synopsis,
    this.writer,
    this.publisher,
    this.releaseDate,
    this.pageAmt,
    this.coverImage,
    this.bookUrl,
    this.category,
    this.currentPage,
  });

  BookModel copyWith({
    int? id,
    String? title,
    String? synopsis,
    String? writer,
    String? publisher,
    DateTime? releaseDate,
    int? pageAmt,
    String? coverImage,
    String? bookUrl,
    BookCategoryModel? category,
    int? currentPage,
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
      bookUrl: bookUrl ?? this.bookUrl,
      category: category ?? this.category,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'writer': writer,
      'publisher': publisher,
      'releaseDate': releaseDate?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
      'pageAmt': pageAmt,
      'coverImage': coverImage,
      'bookUrl': bookUrl,
      'category': category?.toMap(),
      'currentPage': currentPage,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      synopsis: map['synopsis'] as String?,
      writer: map['writer'] as String?,
      publisher: map['publisher'] as String?,
      releaseDate: DateTime.tryParse((map['releaseDate'] as String?) ?? ''),
      pageAmt: map['pageAmt'] as int?,
      coverImage: map['coverImage'] as String?,
      bookUrl: map['bookUrl'] as String?,
      category: map['category'] != null ? BookCategoryModel.fromMap(map['category'] as Map<String, dynamic>) : null,
      currentPage: map['currentPage'] as int?,
    );
  }

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
      bookUrl,
      category,
      currentPage,
    ];
  }
}
