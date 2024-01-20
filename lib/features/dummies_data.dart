//! User
class User {
  final String username;
  final String password;
  final String email;

  const User({
    required this.username,
    required this.password,
    required this.email,
  });
}

const user = User(
  username: 'test123',
  password: 'test123',
  email: 'test@email.com',
);

//!