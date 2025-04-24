// IGNORE FOR NOW!!!

class OptionValue {
  final int? id;
  final String value;
  final int optionId;

  OptionValue({this.id, required this.value, required this.optionId});

  factory OptionValue.fromMap(Map<String, dynamic> map) {
    return OptionValue(
      id: map['id'],
      value: map['value'],
      optionId: map['option_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'value': value, 'option_id': optionId};
  }
}
