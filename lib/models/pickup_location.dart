// IGNORE FOR NOW!!!

class PickupLocation {
  final int? id;
  final int organizationId;
  final String address;
  final String? description;
  final String? createdAt;
  final String? deletedAt;

  PickupLocation({
    this.id,
    required this.address,
    this.description,
    this.createdAt,
    this.deletedAt,
    required this.organizationId,
  });

  factory PickupLocation.fromMap(Map<String, dynamic> map) {
    return PickupLocation(
      id: map['id'],
      address: map['address'],
      description: map['description'] ?? 'Not specified',
      createdAt: map['created_at'],
      deletedAt: map['deleted_at'],
      organizationId: map['organization_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'description': description,
      'organization_id': organizationId,
    };
  }
}
