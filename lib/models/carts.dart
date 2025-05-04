import 'package:clublly/models/product.dart';
import 'package:clublly/models/product_variant.dart';

class Carts {
  final int? id;
  final int productId;
  final String userId;
  final Product? product;
  final int? productVariantId;
  final ProductVariant? productVariant;
  final num quantity;
  final num totalPrice;
  final String? createdAt;

  Carts({
    this.id,
    required this.productId,
    required this.userId,
    this.product,
    this.productVariantId,
    this.productVariant,
    required this.quantity,
    required this.totalPrice,
    this.createdAt,
  });

  factory Carts.fromMap(Map<String, dynamic> map) {
    Product? productObj;
    if (map['products'] != null) {
      productObj = Product.fromMap(map['products']);
    }

    ProductVariant? productVariantObj;
    if (map['productVariants'] != null) {
      productVariantObj = ProductVariant.fromMap(map['productVariants']);
    }

    return Carts(
      id: map['id'],
      userId: map['user_id'],
      product: productObj,
      productId: map['product_id'],
      productVariant: productVariantObj,
      quantity: map['quantity'],
      totalPrice: map['total_price'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'product_id': productId,
      'product_variant_id': productVariantId,
      'quantity': quantity,
      'total_price': totalPrice,
      'created_at': createdAt,
    };
  }
}
