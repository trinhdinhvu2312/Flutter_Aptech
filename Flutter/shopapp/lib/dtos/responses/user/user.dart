import 'package:foodapp/extensions/custon_string.dart';
import 'package:foodapp/dtos/responses/role/role.dart';
import 'package:foodapp/utils/utility.dart';

class User {
  final int? id;
  final String? fullName;
  final String phoneNumber;
  final String email;
  final String? address;
  final String? profileImage;
  final bool isActive;
  final DateTime? dateOfBirth;
  final int? facebookAccountId;
  final int? googleAccountId;
  final Role? role; // Assuming role is a String. Adjust based on actual type.

  User({
    this.id,
    this.fullName,
    required this.phoneNumber,
    this.address,
    required this.email,
    this.profileImage,
    required this.isActive,
    this.dateOfBirth,
    this.facebookAccountId,
    this.googleAccountId,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("haha");
    return User(
      id: json['id'] as int?,
      fullName:  (json['fullname'] as String?)?.toUtf8() ?? '',
      phoneNumber: (json['phone_number'] as String) ?? '',
      email: json['email'] == null ? '' : ((json['email'] as String) ?? ''),
      address: (json['address'] as String?)?.toUtf8() ?? '',
      profileImage: Utility.getUserProfileImageUrl(json['profile_image'] ?? ''),
      isActive: json['is_active'] as bool,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['date_of_birth']),
      facebookAccountId: json['facebook_account_id'] as int?,
      googleAccountId: json['google_account_id'] as int?,
      role: Role.fromJson(json['role']), // This depends on how role is represented in your JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullName,
      'phone_number': phoneNumber,
      'address': address,
      'is_active': isActive,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'facebook_account_id': facebookAccountId,
      'google_account_id': googleAccountId,
      'role': role,
    };
  }
  bool get isNotEmpty {
    return isActive && (phoneNumber.isNotEmpty || (fullName ?? '').isNotEmpty);
  }
}

