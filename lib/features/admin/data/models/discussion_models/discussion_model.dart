// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_category_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_model.dart';

class DiscussionModel extends Equatable {
  final int? id;
  final String? status;
  final String? title;
  final String? description;
  final String? type;
  final DiscussionCategoryModel? category;
  final UserModel? asker;
  final DateTime? createdAt;

  const DiscussionModel({
    this.id,
    this.status,
    this.title,
    this.description,
    this.type,
    this.category,
    this.asker,
    this.createdAt,
  });

  DiscussionModel copyWith({
    int? id,
    String? status,
    String? title,
    String? description,
    String? type,
    DiscussionCategoryModel? category,
    UserModel? asker,
    DateTime? createdAt,
  }) {
    return DiscussionModel(
      id: id ?? this.id,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      asker: asker ?? this.asker,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'status': status,
      'title': title,
      'description': description,
      'type': type,
      'category': category?.toMap(),
      'asker': asker?.toMap(),
      'createdAt': createdAt!.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
    };
  }

  factory DiscussionModel.fromMap(Map<String, dynamic> map) {
    return DiscussionModel(
      id: map['id'] as int?,
      status: map['status'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      type: map['type'] as String?,
      category: DiscussionCategoryModel.fromMap(
        map['category'] as Map<String, dynamic>,
      ),
      asker: UserModel.fromMap(
        map['asker'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.tryParse((map['createdAt'] as String?) ?? ''),
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
      category,
      asker,
      createdAt,
    ];
  }
}
