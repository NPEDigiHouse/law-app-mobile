// Package imports:
import 'package:equatable/equatable.dart';

class ArticleModel extends Equatable {
  final int? id;
  final String? title;
  final String? material;
  final int? duration;

  const ArticleModel({
    this.id,
    this.title,
    this.material,
    this.duration,
  });

  ArticleModel copyWith({
    int? id,
    String? title,
    String? material,
    int? duration,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      material: material ?? this.material,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'material': material,
      'duration': duration,
    };
  }

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      material: map['material'] as String?,
      duration: map['duration'] as int?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title, material, duration];
}
