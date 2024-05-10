import 'package:foodapp/extensions/custon_string.dart';
class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: (json['name'] as String?)?.toUtf8() ?? '',
    );
  }
}
