import 'package:foodapp/services/api_constants.dart';
import 'package:foodapp/utils/utility.dart';

class ProductImage {
  late int id;
  late String imageUrl;

  ProductImage({
    required this.id,
    required this.imageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      imageUrl: Utility.getProductImageUrl(json['image_url'] ?? ''),
    );
  }
}

