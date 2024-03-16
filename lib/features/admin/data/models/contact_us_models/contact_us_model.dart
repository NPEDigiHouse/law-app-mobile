import 'package:equatable/equatable.dart';

class ContactUsModel extends Equatable {
  final int? id;
  final String? addressName;
  final String? addressLink;
  final String? whatsappName;
  final String? whatsappLink;
  final String? emailName;
  final String? emailLink;

  const ContactUsModel({
    this.id,
    this.addressName,
    this.addressLink,
    this.whatsappName,
    this.whatsappLink,
    this.emailName,
    this.emailLink,
  });

  ContactUsModel copyWith({
    int? id,
    String? addressName,
    String? addressLink,
    String? whatsappName,
    String? whatsappLink,
    String? emailName,
    String? emailLink,
  }) {
    return ContactUsModel(
      id: id ?? this.id,
      addressName: addressName ?? this.addressName,
      addressLink: addressLink ?? this.addressLink,
      whatsappName: whatsappName ?? this.whatsappName,
      whatsappLink: whatsappLink ?? this.whatsappLink,
      emailName: emailName ?? this.emailName,
      emailLink: emailLink ?? this.emailLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'addressName': addressName,
      'addressLink': addressLink,
      'whatsappName': whatsappName,
      'whatsappLink': whatsappLink,
      'emailName': emailName,
      'emailLink': emailLink,
    };
  }

  factory ContactUsModel.fromMap(Map<String, dynamic> map) {
    return ContactUsModel(
      id: map['id'] as int?,
      addressName: map['addressName'] as String?,
      addressLink: map['addressLink'] as String?,
      whatsappName: map['whatsappName'] as String?,
      whatsappLink: map['whatsappLink'] as String?,
      emailName: map['emailName'] as String?,
      emailLink: map['emailLink'] as String?,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        id,
        addressName,
        addressLink,
        whatsappName,
        whatsappLink,
        emailName,
        emailLink,
      ];
}
