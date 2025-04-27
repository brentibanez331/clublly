// IGNORE FOR NOW!!!

import 'dart:developer';

import 'package:clublly/models/option_value.dart';
import 'package:clublly/models/product_variant_option_values.dart';

class ProductVariant {
  final int? id;
  final int productId;
  final num price;
  final num stockQuantity;
  final String? createdAt;
  // final List<OptionValue>? optionValues;
  final List<ProductVariantOptionValues>? productVariantOptionValues;

  ProductVariant({
    this.id,
    required this.price,
    required this.productId,
    required this.stockQuantity,
    this.createdAt,
    this.productVariantOptionValues,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    // List all option values
    final List<ProductVariantOptionValues> pvovs =
        (map['productVariantOptionValues'] as List)
            .map((pvov) => ProductVariantOptionValues.fromMap(pvov))
            .toList();

    return ProductVariant(
      id: map['id'],
      price: map['price'],
      productId: map['product_id'],
      stockQuantity: map['stock_quantity'],
      createdAt: map['created_at'],
      productVariantOptionValues: pvovs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'product_id': productId,
      'stock_quantity': stockQuantity,
    };
  }
}
