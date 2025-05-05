class Order {
  final int? id;
  final String referenceCode;
  final num quantity;
  final num totalAmount;
  final String status;
  final String? releaseDate;
  final int pickupLocationId;
  final int productId;
  final String? createdAt;
  final String? updatedAt;
  final String buyerId;
  final int productVariantId;
  final String paymentMethod;

  Order({
    this.id,
    required this.referenceCode,
    required this.quantity,
    required this.buyerId,
    required this.pickupLocationId,
    required this.productId,
    this.releaseDate,
    required this.status,
    required this.totalAmount,
    this.updatedAt,
    this.createdAt,
    required this.productVariantId,
    required this.paymentMethod,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      referenceCode: map['reference_code'],
      quantity: map['quantity'],
      totalAmount: map['total_amount'],
      status: map['status'],
      buyerId: map['buyer_id'],
      pickupLocationId: map['pickup_location_id'],
      productId: map['product_id'],
      releaseDate: map['release_date'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      productVariantId: map['product_variant_id'],
      paymentMethod: map['payment_method'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reference_code': referenceCode,
      'quantity': quantity,
      'total_amount': totalAmount,
      'status': status,
      'pickup_location_id': pickupLocationId,
      'product_id': productId,
      'buyer_id': buyerId,
      'product_variant_id': productVariantId,
      'payment_method': paymentMethod,
    };
  }
}
