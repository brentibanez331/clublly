import 'dart:developer';

import 'package:clublly/models/product_variant.dart';

class Product {
  final int? id;
  final int categoryId;
  final int organizationId;
  final String name;
  final String description;
  final num basePrice;
  final num baseStock;
  final String? createdAt;
  final String? thumbnailUrl;
  final List<String>? additionalImages;
  final String? organizationName;
  final String? organizationAcronym;
  final String? organizationLogo;
  final List<ProductVariant>? productVariants;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.baseStock,
    required this.organizationId,
    required this.categoryId,
    this.createdAt,
    this.thumbnailUrl,
    this.additionalImages,
    this.organizationName,
    this.organizationAcronym,

    this.organizationLogo,
    this.productVariants,
  });

  // Convert a map from Supabase to a Contact object
  factory Product.fromMap(Map<String, dynamic> map) {
    List<ProductVariant>? variantsList;

    if (map['productVariants'] != null) {
      variantsList =
          (map['productVariants'] as List)
              .map((variant) => ProductVariant.fromMap(variant))
              .toList();
    }

    // Calculate base price when it's 0 and variants exist
    num effectiveBasePrice = map['base_price'] ?? 0;
    if (effectiveBasePrice == 0 &&
        variantsList != null &&
        variantsList.isNotEmpty) {
      // Find minimum price from variants
      effectiveBasePrice = variantsList
          .map((variant) => variant.price)
          .reduce((value, element) => value < element ? value : element);
    }

    num effectiveBaseStock = map['base_stock'] ?? 0;
    if (effectiveBaseStock == 0 &&
        variantsList != null &&
        variantsList.isNotEmpty) {
      // Sum all variant stocks
      effectiveBaseStock = variantsList
          .map((variant) => variant.stockQuantity)
          .reduce((sum, quantity) => sum + quantity);
    }

    String? thumbnail;
    List<String>? otherImages;

    if (map['productImages'] != null &&
        (map['productImages'] as List).isNotEmpty) {
      final thumbnailImage = (map['productImages'] as List).firstWhere(
        (img) => img['is_thumbnail'] == true,
      );

      thumbnail = thumbnailImage['image_path'];

      otherImages =
          (map['productImages'] as List)
              .where((img) => img['is_thumbnail'] == false)
              .map((img) => img['image_path'] as String)
              .toList();

      if (otherImages.isEmpty) {
        otherImages = null;
      }
    }

    return Product(
      id: map['id'],
      organizationId: map['organization_id'],
      categoryId: map['category_id'],
      name: map['name'],
      description: map['description'],
      basePrice: effectiveBasePrice,
      baseStock: effectiveBaseStock,
      createdAt: map['created_at'],
      thumbnailUrl: thumbnail,
      additionalImages: otherImages,
      organizationName: map['organizations']?['name'],
      organizationAcronym: map['organizations']?['acronym'],
      organizationLogo: map['organizations']?['logo_path'],
      productVariants: variantsList,
    );
  }

  // Convert a Contact object to a map for insertion/updating
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'base_price': basePrice,
      'base_stock': baseStock,
      'organization_id': organizationId,
      'category_id': categoryId,
    };
  }
}
