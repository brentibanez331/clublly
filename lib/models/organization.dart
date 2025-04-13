class Organization {
  final int id;
  final String name;
  final String description;
  final int departmentId;
  final String ownerId;
  final String acronym;
  final String createdAt;
  final String updatedAt;

  Organization({
    required this.id,
    required this.acronym,
    required this.createdAt,
    required this.departmentId,
    required this.description,
    required this.name,
    required this.ownerId,
    required this.updatedAt,
  });

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      id: map['id'],
      name: map['name'],
      acronym: map['acronym'],
      departmentId: map['department_id'],
      description: map['description'],
      ownerId: map['owner_id'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
