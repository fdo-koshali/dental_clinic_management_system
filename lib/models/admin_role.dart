enum AdminRole {
  dentist,
  assistant,
  supplier,
}

extension AdminRoleExtension on AdminRole {
  String get name {
    switch (this) {
      case AdminRole.dentist:
        return 'Dentist';
      case AdminRole.assistant:
        return 'Assistant';
      case AdminRole.supplier:
        return 'Supplier';
    }
  }

  bool get canEditTreatments {
    return this == AdminRole.dentist;
  }

  bool get canEditPatientHistory {
    return this == AdminRole.dentist;
  }

  bool get canAccessInventory {
    return this == AdminRole.dentist || this == AdminRole.supplier;
  }

  bool get canAccessBilling {
    return this == AdminRole.dentist || this == AdminRole.assistant;
  }

  bool get canEditAppointments {
    return this == AdminRole.dentist || this == AdminRole.assistant;
  }

  static AdminRole fromString(String value) {
    return AdminRole.values.firstWhere(
      (role) => role.name.toLowerCase() == value.toLowerCase(),
      orElse: () => AdminRole.assistant,
    );
  }
}
