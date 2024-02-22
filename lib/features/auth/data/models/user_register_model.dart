// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class UserSignUpModel extends Equatable {
  final String name;
  final String username;
  final String email;
  final String password;
  final String birthDate;
  final String phoneNumber;
  final String role;

  const UserSignUpModel({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.birthDate,
    required this.phoneNumber,
    required this.role,
  });

  UserSignUpModel copyWith({
    String? name,
    String? username,
    String? email,
    String? password,
    String? birthDate,
    String? phoneNumber,
    String? role,
  }) {
    return UserSignUpModel(
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

  factory UserSignUpModel.fromMap(Map<String, dynamic> map) {
    return UserSignUpModel(
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

  factory UserSignUpModel.fromJson(String source) =>
      UserSignUpModel.fromMap(json.decode(source) as Map<String, dynamic>);

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

  @override
  bool get stringify => true;
}
