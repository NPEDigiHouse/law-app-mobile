// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:law_app/core/extensions/datetime_extension.dart';

class UserCredentialModel extends Equatable {
  final String? name;
  final String? username;
  final String? email;
  final DateTime? birthDate;
  final String? phoneNumber;
  final String? role;
  final int? totalWeeklyGeneralQuestionsQuota;
  final int? totalWeeklySpecificQuestionsQuota;

  const UserCredentialModel({
    this.name,
    this.username,
    this.email,
    this.birthDate,
    this.phoneNumber,
    this.role,
    this.totalWeeklyGeneralQuestionsQuota,
    this.totalWeeklySpecificQuestionsQuota,
  });

  UserCredentialModel copyWith({
    String? name,
    String? username,
    String? email,
    DateTime? birthDate,
    String? phoneNumber,
    String? role,
    int? totalWeeklyGeneralQuestionsQuota,
    int? totalWeeklySpecificQuestionsQuota,
  }) {
    return UserCredentialModel(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      totalWeeklyGeneralQuestionsQuota: totalWeeklyGeneralQuestionsQuota ??
          this.totalWeeklyGeneralQuestionsQuota,
      totalWeeklySpecificQuestionsQuota: totalWeeklySpecificQuestionsQuota ??
          this.totalWeeklySpecificQuestionsQuota,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'username': username,
      'email': email,
      'birthDate': birthDate?.toStringPattern("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'"),
      'phoneNumber': phoneNumber,
      'role': role,
      'totalWeeklyGeneralQuestionsQuota': totalWeeklyGeneralQuestionsQuota,
      'totalWeeklySpecificQuestionsQuota': totalWeeklySpecificQuestionsQuota,
    };
  }

  factory UserCredentialModel.fromMap(Map<String, dynamic> map) {
    return UserCredentialModel(
      name: map['name'] as String?,
      username: map['username'] as String?,
      email: map['email'] as String?,
      birthDate: DateTime.tryParse((map['birthDate'] as String?) ?? ''),
      phoneNumber: map['phoneNumber'] as String?,
      role: map['role'] as String?,
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
      name,
      username,
      email,
      birthDate,
      phoneNumber,
      role,
      totalWeeklyGeneralQuestionsQuota,
      totalWeeklySpecificQuestionsQuota,
    ];
  }
}
