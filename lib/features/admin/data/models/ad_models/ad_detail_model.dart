// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';

class AdDetailModel extends Equatable {
  final int? id;
  final String? title;
  final String? content;
  final String? imageName;
  final DateTime? createdAt;

  const AdDetailModel({
    this.id,
    this.title,
    this.content,
    this.imageName,
    this.createdAt,
  });

  AdDetailModel copyWith({
    int? id,
    String? title,
    String? content,
    String? imageName,
    DateTime? createdAt,
  }) {
    return AdDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageName: imageName ?? this.imageName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'imageName': imageName,
      'createdAt': createdAt?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
    };
  }

  factory AdDetailModel.fromMap(Map<String, dynamic> map) {
    return AdDetailModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      content: map['content'] as String?,
      imageName: map['imageName'] as String?,
      createdAt: DateTime.tryParse((map['createdAt'] as String?) ?? ''),
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, title, content, imageName, createdAt];
}
