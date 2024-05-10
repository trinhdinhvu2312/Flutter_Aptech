class CouponRequest {
  final String couponCode;
  final double totalAmount;

  CouponRequest({
    required this.couponCode,
    required this.totalAmount,
  }) : assert(couponCode.isNotEmpty, 'Coupon code must not be empty'),
        assert(totalAmount >= 0, 'Total amount must be greater than or equal to 0');

  Map<String, dynamic> toJson() {
    return {
      'couponCode': couponCode,
      'totalAmount': totalAmount.toString(),
    };
  }
}

