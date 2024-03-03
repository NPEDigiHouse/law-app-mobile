// Package imports:
import 'package:equatable/equatable.dart';

class BookCategoryModel extends Equatable {
  final int? id;
  final String? name;

  const BookCategoryModel({
    this.id,
    this.name,
  });

  BookCategoryModel copyWith({
    int? id,
    String? name,
  }) {
    return BookCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory BookCategoryModel.fromMap(Map<String, dynamic> map) {
    return BookCategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
