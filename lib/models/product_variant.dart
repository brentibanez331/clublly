// IGNORE FOR NOW!!!

class ProductVariant {
  final int id;
  final int productId;
  final num price;
  final num stockQuantity;
  final String createdAt;

  ProductVariant({
    required this.id,
    required this.price,
    required this.productId,
    required this.stockQuantity,
    required this.createdAt,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      id: map['id'],
      price: map['price'],
      productId: map['product_id'],
      stockQuantity: map['stock_quantity'],
      createdAt: map['created_at'],
    );
  }
}
