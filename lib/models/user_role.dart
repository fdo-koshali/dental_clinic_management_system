enum UserRole {
  patient,
  dentist,
  assistant,
  admin,
}

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.dentist:
        return 'Dentist';
      case UserRole.assistant:
        return 'Assistant';
      case UserRole.admin:
        return 'Admin';
    }
  }
}