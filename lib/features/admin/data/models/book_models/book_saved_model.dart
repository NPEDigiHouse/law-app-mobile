import 'package:equatable/equatable.dart';

import 'package:law_app/features/admin/data/models/book_models/book_model.dart';

class BookSavedModel extends Equatable {
  final int? id;
  final BookModel? book;

  const BookSavedModel({
    this.id,
    this.book,
  });

  BookSavedModel copyWith({
    int? id,
    BookModel? book,
  }) {
    return BookSavedModel(
      id: id ?? this.id,
      book: book ?? this.book,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'book': book?.toMap(),
    };
  }

  factory BookSavedModel.fromMap(Map<String, dynamic> map) {
    return BookSavedModel(
      id: map['id'] as int?,
      book: map['book'] != null
          ? BookModel.fromMap(map['book'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, book];
}
