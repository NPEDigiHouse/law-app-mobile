// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';

class UserPostModel extends Equatable {
  final String name;
  final String username;
  final String email;
  final String password;
  final DateTime birthDate;
  final String phoneNumber;
  final String role;
  final List<int> teacherDiscussionCategoryIds;

  const UserPostModel({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.birthDate,
    required this.phoneNumber,
    required this.role,
    required this.teacherDiscussionCategoryIds,
  });

  UserPostModel copyWith({
    String? name,
    String? username,
    String? email,
    String? password,
    DateTime? birthDate,
    String? phoneNumber,
    String? role,
    List<int>? teacherDiscussionCategoryIds,
  }) {
    return UserPostModel(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      teacherDiscussionCategoryIds:
          teacherDiscussionCategoryIds ?? this.teacherDiscussionCategoryIds,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'birthDate': birthDate.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
      'phoneNumber': phoneNumber,
      'role': role,
      'teacherDiscussionCategoryIds': '$teacherDiscussionCategoryIds',
    };
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      username,
      email,
      password,
      birthDate,
      phoneNumber,
      role,
      teacherDiscussionCategoryIds,
    ];
  }
}
