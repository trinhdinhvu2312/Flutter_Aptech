class Favorite {
  final int id;
  final int productId;
  final int userId;

  Favorite({
    required this.id,
    required this.productId,
    required this.userId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as int,
      productId: json['product_id'] ?? 0,
      userId: json['user_id'] ?? 0,
    );
  }
}
