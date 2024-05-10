import 'package:foodapp/dtos/responses/product/product.dart';

class ProductList {
  List<Product> products;
  int totalPages;

  ProductList({
    required this.products,
    required this.totalPages,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) {
    List<dynamic> productsJson = json['products'];
    List<Product> products = productsJson.map(
            (productJson) => Product.fromJson(productJson)).toList();
    return ProductList(
      products: products,
      totalPages: json['totalPages'] as int ,
    );
  }
}