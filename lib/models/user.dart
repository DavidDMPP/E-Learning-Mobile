class User {
  final String uid;
  final String name;
  final String npm;
  final String role;
  final String email;

  User({
    required this.uid,
    required this.name,
    required this.npm,
    required this.role,
    required this.email,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      npm: data['npm'] ?? '',
      role: data['role'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'npm': npm,
      'role': role,
      'email': email,
    };
  }
}
