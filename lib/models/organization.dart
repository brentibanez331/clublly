class Organization {
  final int? id;
  final String name;
  final String description;
  final int departmentId;
  final String ownerId;
  final String acronym;
  final String? logoPath;
  final String? createdAt;
  final String? updatedAt;

  Organization({
    this.id,
    required this.acronym,
    required this.departmentId,
    required this.description,
    required this.name,
    required this.ownerId,
    this.logoPath,
    this.createdAt,
    this.updatedAt,
  });

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      id: map['id'],
      name: map['name'],
      acronym: map['acronym'],
      departmentId: map['department_id'],
      description: map['description'],
      ownerId: map['owner_id'],
      logoPath: map['logo_path'] ?? '',
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'acronym': acronym,
      'department_id': departmentId,
      'description': description,
      'owner_id': ownerId,
      'logo_path': logoPath,
    };
  }
}
