class Category {
  final int id;
  final String name;
  final String createdAt;
  final String imagePath;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.imagePath,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      createdAt: map['created_at'],
      imagePath: map['image_path'],
    );
  }
}
