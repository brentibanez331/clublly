class Option {
  final int? id;
  final String type;

  Option({this.id, required this.type});

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(id: map['id'], type: map['type']);
  }
}
