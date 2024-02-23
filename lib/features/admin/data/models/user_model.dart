// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';

class UserModel extends Equatable {
  final int? id;
  final String? name;
  final String? username;
  final String? email;
  final DateTime? birthDate;
  final String? phoneNumber;
  final String? role;

  const UserModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.birthDate,
    this.phoneNumber,
    this.role,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    DateTime? birthDate,
    String? phoneNumber,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'birthDate': birthDate?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String?,
      username: map['username'] as String?,
      email: map['email'] as String?,
      birthDate: DateTime.tryParse((map['birthDate'] as String?) ?? ''),
      phoneNumber: map['phoneNumber'] as String?,
      role: map['role'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props {
    return [
      id,
      name,
      username,
      email,
      birthDate,
      phoneNumber,
      role,
    ];
  }

  @override
  bool get stringify => true;
}
