// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/features/admin/data/models/discussion_category_model.dart';

class UserModel extends Equatable {
  final int? id;
  final String? role;
  final String? name;
  final String? username;
  final String? email;
  final DateTime? birthDate;
  final String? phoneNumber;
  final String? profilePicture;
  final List<DiscussionCategoryModel>? expertises;

  const UserModel({
    this.id,
    this.role,
    this.name,
    this.username,
    this.email,
    this.birthDate,
    this.phoneNumber,
    this.profilePicture,
    this.expertises,
  });

  UserModel copyWith({
    int? id,
    String? role,
    String? name,
    String? username,
    String? email,
    DateTime? birthDate,
    String? phoneNumber,
    String? profilePicture,
    List<DiscussionCategoryModel>? expertises,
  }) {
    return UserModel(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      expertises: expertises ?? this.expertises,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'role': role,
      'name': name,
      'username': username,
      'email': email,
      'birthDate': birthDate?.toStringPattern("dd MMMM yyyy"),
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'expertises': expertises?.map((e) => e.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      role: map['role'] as String?,
      name: map['name'] as String?,
      username: map['username'] as String?,
      email: map['email'] as String?,
      birthDate: DateTime.tryParse((map['birthDate'] as String?) ?? ''),
      phoneNumber: map['phoneNumber'] as String?,
      profilePicture: map['profilePicture'] as String?,
      expertises: List<DiscussionCategoryModel>.from(
        (map['teacherDiscussionCategories'] as List).map(
          (e) => DiscussionCategoryModel.fromMap(e as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      role,
      name,
      username,
      email,
      birthDate,
      phoneNumber,
      profilePicture,
      expertises,
    ];
  }
}
