class Order {
  final int id;
  final String referenceCode;
  final num quantity;
  final num totalAmount;
  final String status;
  final String releaseDate;
  final int pickupLocationId;
  final int productId;
  final String createdAt;
  final String updatedAt;
  final String buyerId;

  Order({
    required this.id,
    required this.referenceCode,
    required this.quantity,
    required this.buyerId,
    required this.pickupLocationId,
    required this.productId,
    required this.releaseDate,
    required this.status,
    required this.totalAmount,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      referenceCode: map['reference_code'],
      buyerId: map['buyer_id'],
      pickupLocationId: map['pickup_location_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      releaseDate: map['release_date'],
      status: map['status'],
      totalAmount: map['total_amount'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
