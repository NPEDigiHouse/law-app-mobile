// Package imports:
import 'package:equatable/equatable.dart';

class MaterialModel extends Equatable {
  final int? id;
  final String? title;
  final int? duration;

  const MaterialModel({
    this.id,
    this.title,
    this.duration,
  });

  MaterialModel copyWith({
    int? id,
    String? title,
    int? duration,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'duration': duration,
    };
  }

  factory MaterialModel.fromMap(Map<String, dynamic> map) {
    return MaterialModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      duration: map['duration'] as int?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title, duration];
}
