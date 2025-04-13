// IGNORE FOR NOW!!!

class PickupLocation {
  final int id;
  final int organizationId;
  final String address;
  final String createdAt;
  final String deletedAt;

  PickupLocation({
    required this.id,
    required this.address,
    required this.createdAt,
    required this.deletedAt,
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
}
