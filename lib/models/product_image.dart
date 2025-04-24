class ProductImage {
  final int? id;
  final int productId;
  final bool isThumbnail;
  final String? createdAt;
  final String imagePath;

  ProductImage({
    this.id,
    required this.imagePath,
    this.createdAt,
    required this.isThumbnail,
    required this.productId,
  });

  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage(
      id: map['id'],
      imagePath: map['image_path'],
      createdAt: map['created_at'],
      isThumbnail: map['is_thumbnail'],
      productId: map['product_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image_path': imagePath,
      'product_id': productId,
      'is_thumbnail': isThumbnail,
    };
  }
}
