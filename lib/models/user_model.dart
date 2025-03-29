<<<<<<< HEAD
import 'user_role.dart';
=======
enum UserRole { user, dentist, assistant }
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d

class UserModel {
  final String uid;
  final String email;
<<<<<<< HEAD
  final String name;
  final UserRole role;
  final String? phoneNumber;
=======
  final String? name;
  final UserRole role;
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d

  UserModel({
    required this.uid,
    required this.email,
<<<<<<< HEAD
    required this.name,
    required this.role,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role.name,
      'phoneNumber': phoneNumber,
    };
  }

=======
    this.name,
    required this.role,
  });

>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      role: UserRole.values.firstWhere(
<<<<<<< HEAD
        (role) => role.name == map['role'],
        orElse: () => UserRole.patient,
      ),
      phoneNumber: map['phoneNumber'],
    );
  }
=======
        (e) => e.toString() == 'UserRole.${map['role']}',
        orElse: () => UserRole.user,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
    };
  }
>>>>>>> 9f53d74438980645eab1132d1bcab971b924c26d
}