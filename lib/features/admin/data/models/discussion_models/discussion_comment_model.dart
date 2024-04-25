// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/features/admin/data/models/user_models/user_model.dart';

class DiscussionCommentModel extends Equatable {
  final int? id;
  final String? text;
  final DateTime? createdAt;
  final UserModel? user;

  const DiscussionCommentModel({
    this.id,
    this.text,
    this.createdAt,
    this.user,
  });

  DiscussionCommentModel copyWith({
    int? id,
    String? text,
    DateTime? createdAt,
    UserModel? user,
  }) {
    return DiscussionCommentModel(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
      'user': user?.toMap(),
    };
  }

  factory DiscussionCommentModel.fromMap(Map<String, dynamic> map) {
    return DiscussionCommentModel(
      id: map['id'] as int?,
      text: map['text'] as String?,
      createdAt: DateTime.tryParse((map['createdAt'] as String?) ?? ''),
      user: map['user'] != null ? UserModel.fromMap(map['user'] as Map<String, dynamic>) : null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        text,
        createdAt,
        user,
      ];
}
