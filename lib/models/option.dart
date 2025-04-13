// IGNORE FOR NOW!!!

class Option {
  final int id;
  final String type;
  final String createdAt;

  Option({required this.id, required this.type, required this.createdAt});

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      id: map['id'],
      type: map['type'],
      createdAt: map['created_at'],
    );
  }
}
