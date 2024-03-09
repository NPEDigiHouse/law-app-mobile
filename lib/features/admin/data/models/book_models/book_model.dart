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
  final BookCategoryModel? category;
  final int? currentPage;
  final DateTime? lastOpened;

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
    this.currentPage,
    this.lastOpened,
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
    BookCategoryModel? category,
    int? currentPage,
    DateTime? lastOpened,
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
      currentPage: currentPage ?? this.currentPage,
      lastOpened: lastOpened ?? this.lastOpened,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'writer': writer,
      'publisher': publisher,
      'releaseDate':
          releaseDate?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
      'pageAmt': pageAmt,
      'coverImage': coverImage,
      'category': category?.toMap(),
      'currentPage': currentPage,
      'lastOpened': lastOpened?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
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
      category: map['category'] != null
          ? BookCategoryModel.fromMap(map['category'] as Map<String, dynamic>)
          : null,
      currentPage: map['currentPage'] as int?,
      lastOpened: DateTime.tryParse((map['lastOpened'] as String?) ?? ''),
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
      category,
      currentPage,
      lastOpened,
    ];
  }
}
