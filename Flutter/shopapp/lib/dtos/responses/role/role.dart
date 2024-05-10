import 'package:foodapp/extensions/custon_string.dart';

class Role {
  final int id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: (json['name'] as String?)?.toUtf8() ?? '',
    );
  }
}