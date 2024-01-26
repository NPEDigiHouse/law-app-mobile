// ignore_for_file: public_member_api_docs, sort_constructors_first
//! User
class User {
  final String username;
  final String password;
  final String email;
  final int otp;
  final int roleId;
  
  const User({
    required this.username,
    required this.password,
    required this.email,
    required this.otp,
    required this.roleId,
  });
}

const user = User(
  username: 'test123',
  password: 'test123',
  email: 'test@gmail.com',
  otp: 1234,
  roleId: 1,
);

//!
class Glossary {
  
}