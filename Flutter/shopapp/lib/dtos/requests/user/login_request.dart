class LoginRequest {
  final String? phoneNumber;
  final String? email;
  final String password;
  int roleId;

  LoginRequest({
    this.phoneNumber,
    this.email,
    required this.password,
    int? roleId,
  })  :
        assert(password.isNotEmpty, 'Password cannot be blank'),
        assert(phoneNumber != null || email != null, 'At least phoneNumber or email must not be blank'), // Check if at least one of phoneNumber or email is provided
        roleId = roleId ?? 1; // Default value for roleId

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber ?? '',
      'email': email ?? '',
      'password': password ?? '',
      'role_id': roleId ?? 1,
    };
  }
}



