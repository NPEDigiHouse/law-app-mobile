import 'package:equatable/equatable.dart';

class AdModel extends Equatable{
  final int? id;
  final String? title;
  final String? content;
  final String? imageName;

  const AdModel({
    this.id,
    this.title,
    this.content,
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
      content: content ?? this.content,
      imageName: imageName ?? this.imageName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'imageName': imageName,
    };
  }

  factory AdModel.fromMap(Map<String, dynamic> map) {
    return AdModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      content: map['content'] as String?,
      imageName: map['imageName'] as String?,
    );
  }
  
  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id, title, content, imageName];

}
