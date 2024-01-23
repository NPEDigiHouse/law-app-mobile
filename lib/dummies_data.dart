// ignore_for_file: public_member_api_docs, sort_constructors_first
//! User
class User {
  final String username;
  final String password;
  final String email;
  final int otp;
  final int role;

  const User({
    required this.username,
    required this.password,
    required this.email,
    required this.otp,
    required this.role,
  });
}

const user = User(
  username: 'test123',
  password: 'test123',
  email: 'test@gmail.com',
  otp: 1234,
  role: 2 // 0 : admin, 1 : pakar, 2 : siswa (sample)
);

//!