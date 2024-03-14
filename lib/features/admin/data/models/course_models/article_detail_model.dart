// Package imports:
import 'package:equatable/equatable.dart';

class ArticleDetailModel extends Equatable {
  final int? id;
  final String? title;
  final String? material;
  final int? duration;

  const ArticleDetailModel({
    this.id,
    this.title,
    this.material,
    this.duration,
  });

  ArticleDetailModel copyWith({
    int? id,
    String? title,
    String? material,
    int? duration,
  }) {
    return ArticleDetailModel(
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

  factory ArticleDetailModel.fromMap(Map<String, dynamic> map) {
    return ArticleDetailModel(
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
