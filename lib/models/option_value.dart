// IGNORE FOR NOW!!!

class OptionValue {
  final int id;
  final String value;
  final int optionId;

  OptionValue({required this.id, required this.value, required this.optionId});

  factory OptionValue.fromMap(Map<String, dynamic> map) {
    return OptionValue(
      id: map['id'],
      value: map['value'],
      optionId: map['created_at'],
    );
  }
}
