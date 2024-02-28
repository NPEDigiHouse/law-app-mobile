// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class UserPostModel extends Equatable {
  final String name;
  final String username;
  final String email;
  final String password;
  final String birthDate;
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
    String? birthDate,
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber,
      'role': role,
      'teacherDiscussionCategoryIds': teacherDiscussionCategoryIds,
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
