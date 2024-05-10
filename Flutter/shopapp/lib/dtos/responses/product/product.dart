import 'package:foodapp/dtos/responses/comment/comment.dart';
import 'package:foodapp/dtos/responses/favorite/favorite.dart';
import 'package:foodapp/dtos/responses/product_image/product_image.dart';
import 'package:foodapp/extensions/custon_string.dart';
import 'package:foodapp/pages/tab/favorites/favorites.dart';
import 'package:foodapp/services/api_constants.dart';
import 'package:foodapp/utils/utility.dart';

class Product  {
  late int id;
  late String name;
  late double price;
  late String thumbnail;
  late String description;
  late int totalPages; // This field is not present in the provided Java class

  List<ProductImage> productImages = [];
  List<Comment> comments = [];
  List<Favorite> favorites = [];
  late int categoryId;
  bool isLiked = false;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.thumbnail,
    required this.description,
    required this.totalPages,
    required this.productImages,
    required this.comments,
    required this.favorites,
    required this.categoryId,
  });
  static Product get empty => Product(
    id: 0,
    name: '',
    price: 0.0,
    thumbnail: Utility.getProductImageUrl(''),
    description: '',
    totalPages: 0,
    productImages: [],
    comments: [],
    favorites: [],
    categoryId: 0,
  );
  factory Product.fromJson(Map<String, dynamic> json) {
    List<dynamic> productImagesJson = json['product_images'];
    List<ProductImage> productImages = productImagesJson.map(
            (imageJson) => ProductImage.fromJson(imageJson)).toList();
    List<Comment> comments = (json['comments'] as List<dynamic>? ?? []).map(
            (commentJson) => Comment.fromJson(commentJson as Map<String, dynamic>)
    ).toList();
    List<Favorite> favorites = (json['favorites'] as List<dynamic>? ?? []).map(
            (favoriteJson) => Favorite.fromJson(favoriteJson as Map<String, dynamic>)
    ).toList();

    return Product(
      id: json['id'] ?? 0,
      name: (json['name'] as String?)?.toUtf8() ?? '',
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      thumbnail: Utility.getProductImageUrl(json['thumbnail'] ?? ''),
      description: (json['description'] as String?)?.toUtf8() ?? '',
      totalPages: json['totalPages'] ?? 0,
      productImages: productImages ?? [],
      comments: comments ?? [],
      favorites: favorites ?? [],
      categoryId: json['category_id'] ?? 0,
    );
  }
}