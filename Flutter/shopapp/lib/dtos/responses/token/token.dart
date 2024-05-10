
import 'package:foodapp/dtos/responses/user/user.dart';

class Token {
  final int id;
  final String token;
  final String refreshToken;
  final String tokenType;
  final String expirationDate;
  final String refreshExpirationDate;
  final bool isMobile;
  final bool revoked;
  final bool expired;
  final User user;

  Token({
    required this.id,
    required this.token,
    required this.refreshToken,
    required this.tokenType,
    required this.expirationDate,
    required this.refreshExpirationDate,
    required this.isMobile,
    required this.revoked,
    required this.expired,
    required this.user,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      id: json['id'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      tokenType: json['tokenType'],
      expirationDate: json['expirationDate'],
      refreshExpirationDate: json['refreshExpirationDate'],
      isMobile: json['isMobile'],
      revoked: json['revoked'],
      expired: json['expired'],
      user: User.fromJson(json['user']),
    );
  }
}