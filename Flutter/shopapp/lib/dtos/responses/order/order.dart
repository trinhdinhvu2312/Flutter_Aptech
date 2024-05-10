import 'package:foodapp/dtos/responses/order/order_detail.dart';
import 'package:foodapp/extensions/custon_string.dart';


class Order {
  final int id;
  final int userId;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String address;
  final String note;
  final DateTime orderDate;
  final String status;
  final double totalMoney;
  final String shippingMethod;
  final String shippingAddress;
  final DateTime shippingDate;
  final String paymentMethod;
  final List<OrderDetail> orderDetails;

  Order({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.note,
    required this.orderDate,
    required this.status,
    required this.totalMoney,
    required this.shippingMethod,
    required this.shippingAddress,
    required this.shippingDate,
    required this.paymentMethod,
    required this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderDetail> orderDetails =  (json['order_details'] as List<dynamic>)
        .map((e) => OrderDetail.fromJson(e as Map<String, dynamic>))
        .toList();
    return Order(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      fullName: (json['fullname'] as String?)?.toUtf8() ?? '',
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      address: (json['address'] as String?)?.toUtf8() ?? '',
      note: (json['note'] as String?)?.toUtf8() ?? '',
      orderDate: DateTime.parse(json['order_date']),
      status: json['status'] as String,
      totalMoney: (json['total_money'] as num).toDouble(),
      shippingMethod: (json['shipping_method'] as String?)?.toUtf8() ?? '',
      shippingAddress: (json['shipping_address'] as String?)?.toUtf8() ?? '',
      shippingDate: json['shipping_date'] != null
                      ? DateTime.parse(json['shipping_date'])
                      : DateTime.now(),
      paymentMethod: (json['payment_method'] as String?)?.toUtf8() ?? '',
      orderDetails: orderDetails,
    );
  }
}
