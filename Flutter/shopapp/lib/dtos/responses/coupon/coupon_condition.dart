import 'package:foodapp/dtos/responses/coupon/coupon.dart';
import 'package:foodapp/extensions/custon_string.dart';

class CouponCondition {
  final int id;
  final Coupon coupon;
  final String attribute;
  final String operator;
  final String value;
  final double discountAmount;

  CouponCondition({
    required this.id,
    required this.coupon,
    required this.attribute,
    required this.operator,
    required this.value,
    required this.discountAmount,
  });

  factory CouponCondition.fromJson(Map<String, dynamic> json) {
    return CouponCondition(
      id: json['id'],
      coupon: Coupon.fromJson(json['coupon']),
      attribute: (json['attribute'] as String?)?.toUtf8() ?? '',
      operator: json['operator'],
      value: json['value'],
      discountAmount: json['discount_amount'].toDouble(),
    );
  }
}
