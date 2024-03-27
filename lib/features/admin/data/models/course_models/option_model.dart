// Package imports:
import 'package:equatable/equatable.dart';

class OptionModel extends Equatable {
  final int? id;
  final String? title;

  const OptionModel({
    this.id,
    this.title,
  });

  OptionModel copyWith({
    int? id,
    String? title,
  }) {
    return OptionModel(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
    };
  }

  factory OptionModel.fromMap(Map<String, dynamic> map) {
    return OptionModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, title];
}
