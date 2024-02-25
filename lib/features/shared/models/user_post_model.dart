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

  const UserPostModel({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.birthDate,
    required this.phoneNumber,
    required this.role,
  });

  UserPostModel copyWith({
    String? name,
    String? username,
    String? email,
    String? password,
    String? birthDate,
    String? phoneNumber,
    String? role,
  }) {
    return UserPostModel(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
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
    };
  }

  factory UserPostModel.fromMap(Map<String, dynamic> map) {
    return UserPostModel(
      name: map['name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      birthDate: map['birthDate'] as String,
      phoneNumber: map['phoneNumber'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPostModel.fromJson(String source) =>
      UserPostModel.fromMap(json.decode(source) as Map<String, dynamic>);

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
    ];
  }
}
