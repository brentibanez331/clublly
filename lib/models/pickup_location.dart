// IGNORE FOR NOW!!!

class PickupLocation {
  final int? id;
  final int organizationId;
  final String address;
  final String? createdAt;
  final String? deletedAt;

  PickupLocation({
    this.id,
    required this.address,
    this.createdAt,
    this.deletedAt,
    required this.organizationId,
  });

  factory PickupLocation.fromMap(Map<String, dynamic> map) {
    return PickupLocation(
      id: map['id'],
      address: map['address'],
      createdAt: map['created_at'],
      deletedAt: map['deleted_at'],
      organizationId: map['organization_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'address': address, 'organization_id': organizationId};
  }
}
