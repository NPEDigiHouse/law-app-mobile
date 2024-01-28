// ignore_for_file: public_member_api_docs, sort_constructors_first
//! User
class User {
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String dateOfBirth;
  final String phone;
  final int otp;
  final int roleId;
  
  const User({
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    required this.phone,
    required this.otp,
    required this.roleId,
  });
}

const user = User(
  username: 'test123',
  password: 'test123',
  fullName: 'testing',
  email: 'test@gmail.com',
  dateOfBirth: '21 Mei 2001',
  phone: '0897182974',
  otp: 1234,
  roleId: 2,
);

//!
class Glossary {
  
}