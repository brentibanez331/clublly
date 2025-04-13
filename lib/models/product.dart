class Product {
  final int id;
  final int categoryId;
  final int organizationId;
  final String name;
  final String description;
  final num basePrice;
  final num baseStock;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.baseStock,
    required this.organizationId,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a map from Supabase to a Contact object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      organizationId: map['organization_id'],
      categoryId: map['category_id'],
      name: map['name'],
      description: map['description'],
      basePrice: map['base_price'],
      baseStock: map['base_stock'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  // Convert a Contact object to a map for insertion/updating
  // Map<String, dynamic> toMap() {
  //   return {
  //     'productName': productName,
  //     'quantity': quantity,
  //     'price': price,
  //     'totalPrice': totalPrice,
  //   };
  // }
}
