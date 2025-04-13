// IGNORE FOR NOW!!!

class ProductVariantOption {
  final int id;
  final int optionValueId;
  final int productVariantId;
  final String createdAt;

  ProductVariantOption({
    required this.id,
    required this.optionValueId,
    required this.productVariantId,
    required this.createdAt,
  });

  factory ProductVariantOption.fromMap(Map<String, dynamic> map) {
    return ProductVariantOption(
      id: map['id'],
      optionValueId: map['option_value_id'],
      productVariantId: map['product_variant_id'],
      createdAt: map['created_at'],
    );
  }
}
