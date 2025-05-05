class ProductOption {
  final int id;
  final int productId;
  final int optionId;
  final String createdAt;

  ProductOption({
    required this.id,
    required this.productId,
    required this.optionId,
    required this.createdAt,
  });

  factory ProductOption.fromMap(Map<String, dynamic> map) {
    return ProductOption(
      id: map['id'],
      productId: map['product_id'],
      optionId: map['option_id'],
      createdAt: map['created_at'],
    );
  }
}
