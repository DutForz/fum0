enum RegistrationMethod {
  email,
  phone,
  google;

  static RegistrationMethod fromString(String? value) {
    switch (value) {
      case 'phone':
        return RegistrationMethod.phone;
      case 'google':
        return RegistrationMethod.google;
      default:
        return RegistrationMethod.email;
    }
  }

  String toFirestoreValue() => name;
}
