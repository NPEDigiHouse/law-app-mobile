// Package imports:
import 'package:equatable/equatable.dart';

class DiscussionCategoryModel extends Equatable {
  final int? id;
  final String? name;

  const DiscussionCategoryModel({
    this.id,
    this.name,
  });

  DiscussionCategoryModel copyWith({
    int? id,
    String? name,
  }) {
    return DiscussionCategoryModel(
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

  factory DiscussionCategoryModel.fromMap(Map<String, dynamic> map) {
    return DiscussionCategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name];
}
