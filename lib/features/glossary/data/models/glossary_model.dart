// Package imports:
import 'package:equatable/equatable.dart';

class GlossaryModel extends Equatable {
  final int? id;
  final String? title;
  final String? description;

  const GlossaryModel({
    this.id,
    this.title,
    this.description,
  });

  GlossaryModel copyWith({
    int? id,
    String? title,
    String? description,
  }) {
    return GlossaryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory GlossaryModel.fromMap(Map<String, dynamic> map) {
    return GlossaryModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      description: map['description'] as String?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title, description];
}
