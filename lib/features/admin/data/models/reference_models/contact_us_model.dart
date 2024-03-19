// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class ContactUsModel extends Equatable {
  final String? whatsappName;
  final String? whatsappLink;
  final String? emailName;
  final String? emailLink;
  final String? addressName;
  final String? addressLink;

  const ContactUsModel({
    this.whatsappName,
    this.whatsappLink,
    this.emailName,
    this.emailLink,
    this.addressName,
    this.addressLink,
  });

  ContactUsModel copyWith({
    String? whatsappName,
    String? whatsappLink,
    String? emailName,
    String? emailLink,
    String? addressName,
    String? addressLink,
  }) {
    return ContactUsModel(
      whatsappName: whatsappName ?? this.whatsappName,
      whatsappLink: whatsappLink ?? this.whatsappLink,
      emailName: emailName ?? this.emailName,
      emailLink: emailLink ?? this.emailLink,
      addressName: addressName ?? this.addressName,
      addressLink: addressLink ?? this.addressLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'whatsappName': whatsappName,
      'whatsappLink': whatsappLink,
      'emailName': emailName,
      'emailLink': emailLink,
      'addressName': addressName,
      'addressLink': addressLink,
    };
  }

  factory ContactUsModel.fromMap(Map<String, dynamic> map) {
    return ContactUsModel(
      whatsappName: map['whatsappName'] as String?,
      whatsappLink: map['whatsappLink'] as String?,
      emailName: map['emailName'] as String?,
      emailLink: map['emailLink'] as String?,
      addressName: map['addressName'] as String?,
      addressLink: map['addressLink'] as String?,
    );
  }

  String toJson() => jsonEncode(toMap());

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        whatsappName,
        whatsappLink,
        emailName,
        emailLink,
        addressName,
        addressLink,
      ];
}
