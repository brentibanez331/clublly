class Department {
  final int id;
  final String name;
  final String createdAt;

  Department({required this.id, required this.name, required this.createdAt});

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'],
      name: map['name'],
      createdAt: map['created_at'],
    );
  }
}
