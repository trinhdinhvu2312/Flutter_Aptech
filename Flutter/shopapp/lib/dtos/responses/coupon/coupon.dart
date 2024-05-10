class Coupon {
  final int id;
  final String code;
  final bool active;

  Coupon({
    required this.id,
    required this.code,
    required this.active,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      code: json['code'],
      active: json['active'],
    );
  }
}
