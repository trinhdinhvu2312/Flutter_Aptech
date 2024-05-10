import 'package:foodapp/utils/utility.dart';

class OrderDetail {
  int id;
  String color;
  int orderId;
  int productId;
  String productName;
  String thumbnail;
  double price;
  int numberOfProducts;
  double totalMoney;

  OrderDetail({
    required this.id,
    required this.color,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.thumbnail,
    required this.price,
    required this.numberOfProducts,
    required this.totalMoney,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'] ?? 0,
      color: json['color'] ?? '',
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      thumbnail: Utility.getProductImageUrl(json['thumbnail'] ?? ''),
      price: json['price']?.toDouble() ?? 0.0,
      numberOfProducts: json['number_of_products'] ?? 0,
      totalMoney: json['total_money']?.toDouble() ?? 0.0,
    );
  }
}