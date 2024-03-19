// Package imports:
import 'package:equatable/equatable.dart';

class AdModel extends Equatable {
  final int? id;
  final String? title;
  final String? imageName;

  const AdModel({
    this.id,
    this.title,
    this.imageName,
  });

  AdModel copyWith({
    int? id,
    String? title,
    String? content,
    String? imageName,
  }) {
    return AdModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageName: imageName ?? this.imageName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'imageName': imageName,
    };
  }

  factory AdModel.fromMap(Map<String, dynamic> map) {
    return AdModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      imageName: map['imageName'] as String?,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, title, imageName];
}
