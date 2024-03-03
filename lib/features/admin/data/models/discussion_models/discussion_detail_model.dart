// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_category_model.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_comment_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_model.dart';

class DiscussionDetailModel extends Equatable {
  final int? id;
  final String? status;
  final String? title;
  final String? description;
  final String? type;
  final DateTime? createdAt;
  final DiscussionCategoryModel? category;
  final UserModel? asker;
  final UserModel? handler;
  final List<DiscussionCommentModel>? comments;

  const DiscussionDetailModel({
    this.id,
    this.status,
    this.title,
    this.description,
    this.type,
    this.createdAt,
    this.category,
    this.asker,
    this.handler,
    this.comments,
  });

  DiscussionDetailModel copyWith({
    int? id,
    String? status,
    String? title,
    String? description,
    String? type,
    DateTime? createdAt,
    DiscussionCategoryModel? category,
    UserModel? asker,
    UserModel? handler,
    List<DiscussionCommentModel>? comments,
  }) {
    return DiscussionDetailModel(
      id: id ?? this.id,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      asker: asker ?? this.asker,
      handler: handler ?? this.handler,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'title': title,
      'description': description,
      'type': type,
      'createdAt': createdAt?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
      'category': category?.toMap(),
      'asker': asker?.toMap(),
      'handler': handler?.toMap(),
      'comments': comments?.map((e) => e.toMap()).toList(),
    };
  }

  factory DiscussionDetailModel.fromMap(Map<String, dynamic> map) {
    return DiscussionDetailModel(
      id: map['id'] as int?,
      status: map['status'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      type: map['type'] as String?,
      createdAt: DateTime.tryParse((map['createdAt'] as String?) ?? ''),
      category: map['category'] != null
          ? DiscussionCategoryModel.fromMap(
              map['category'] as Map<String, dynamic>,
            )
          : null,
      asker: map['asker'] != null
          ? UserModel.fromMap(map['asker'] as Map<String, dynamic>)
          : null,
      handler: map['handler'] != null
          ? UserModel.fromMap(map['handler'] as Map<String, dynamic>)
          : null,
      comments: map['comments'] != null
          ? List<DiscussionCommentModel>.from(
              (map['comments'] as List).map(
                (e) => DiscussionCommentModel.fromMap(
                  e as Map<String, dynamic>,
                ),
              ),
            )
          : null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      status,
      title,
      description,
      type,
      createdAt,
      category,
      asker,
      handler,
      comments,
    ];
  }
}
