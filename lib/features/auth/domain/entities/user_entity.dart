class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final int? guardianId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.guardianId,
  });
}
