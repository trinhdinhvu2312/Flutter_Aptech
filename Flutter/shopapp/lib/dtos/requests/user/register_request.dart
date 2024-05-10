import 'package:intl/intl.dart';

class RegisterRequest {
  final String phoneNumber;
  final String email;
  final String password;
  final String retypePassword;
  final String fullName;
  final String address;
  final DateTime dateOfBirth;
  int roleId;

  RegisterRequest({
    required this.fullName,
    required this.password,
    required this.retypePassword,
    required this.dateOfBirth,
    required String? phoneNumber,
    required String? email,
    String? address,
    int? roleId,
  })  : assert(phoneNumber != null || email != null, 'At least phoneNumber or email is required'),
        assert(password.isNotEmpty, 'Password cannot be blank'),
        assert(password == retypePassword, 'Passwords do not match'),
        assert(_calculateAge(dateOfBirth) >= 18, 'Age must be 18 or above'),
        roleId = roleId ?? 1,
        phoneNumber = phoneNumber ?? '',
        email = email ?? '',
        address = address ?? '';

  // Helper method to calculate age
  static int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    final age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      return age - 1;
    }
    return age;
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullName,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'password': password,
      'retype_password': retypePassword,
      'date_of_birth': DateFormat('yyyy-MM-dd').format(dateOfBirth), // Convert date to 'yyyy-MM-dd' format
      'role_id': roleId,
    };
  }
}

