// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/features/admin/data/models/discussion_category_model.dart';

class UserCredentialModel extends Equatable {
  final int? id;
  final String? role;
  final String? name;
  final String? username;
  final String? email;
  final DateTime? birthDate;
  final String? phoneNumber;
  final String? profilePicture;
  final List<DiscussionCategoryModel>? expertises;
  final int? totalWeeklyGeneralQuestionsQuota;
  final int? totalWeeklySpecificQuestionsQuota;

  const UserCredentialModel({
    this.id,
    this.role,
    this.name,
    this.username,
    this.email,
    this.birthDate,
    this.phoneNumber,
    this.profilePicture,
    this.expertises,
    this.totalWeeklyGeneralQuestionsQuota,
    this.totalWeeklySpecificQuestionsQuota,
  });

  UserCredentialModel copyWith({
    int? id,
    String? role,
    String? name,
    String? username,
    String? email,
    DateTime? birthDate,
    String? phoneNumber,
    String? profilePicture,
    List<DiscussionCategoryModel>? expertises,
    int? totalWeeklyGeneralQuestionsQuota,
    int? totalWeeklySpecificQuestionsQuota,
  }) {
    return UserCredentialModel(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      expertises: expertises ?? this.expertises,
      totalWeeklyGeneralQuestionsQuota: totalWeeklyGeneralQuestionsQuota ??
          this.totalWeeklyGeneralQuestionsQuota,
      totalWeeklySpecificQuestionsQuota: totalWeeklySpecificQuestionsQuota ??
          this.totalWeeklySpecificQuestionsQuota,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'role': role,
      'name': name,
      'username': username,
      'email': email,
      'birthDate': birthDate?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'teacherDiscussionCategories': expertises?.map((e) => e.toMap()).toList(),
      'totalWeeklyGeneralQuestionsQuota': totalWeeklyGeneralQuestionsQuota,
      'totalWeeklySpecificQuestionsQuota': totalWeeklySpecificQuestionsQuota,
    };
  }

  factory UserCredentialModel.fromMap(Map<String, dynamic> map) {
    return UserCredentialModel(
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
      totalWeeklyGeneralQuestionsQuota:
          map['totalWeeklyGeneralQuestionsQuota'] as int?,
      totalWeeklySpecificQuestionsQuota:
          map['totalWeeklySpecificQuestionsQuota'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCredentialModel.fromJson(String source) =>
      UserCredentialModel.fromMap(json.decode(source) as Map<String, dynamic>);

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
      totalWeeklyGeneralQuestionsQuota,
      totalWeeklySpecificQuestionsQuota,
    ];
  }
}
