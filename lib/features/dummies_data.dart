//! User
class User {
  final String username;
  final String password;
  final String email;
  final int otp;

  const User({
    required this.username,
    required this.password,
    required this.email,
    required this.otp,
  });
}

const user = User(
  username: 'test123',
  password: 'test123',
  email: 'test@email.com',
  otp: 123456,
);

//!