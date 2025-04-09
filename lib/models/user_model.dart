enum UserRole { user, admin, dentist, assistant, patient }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final String? phoneNumber;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
  });
}