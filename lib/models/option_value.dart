import 'package:clublly/models/option.dart';

class OptionValue {
  final int? id;
  final String value;
  final int optionId;
  final Option? options;

  OptionValue({
    this.id,
    required this.value,
    required this.optionId,
    this.options,
  });

  factory OptionValue.fromMap(Map<String, dynamic> map) {
    return OptionValue(
      id: map['id'],
      value: map['value'],
      optionId: map['option_id'],
      options: Option.fromMap(map['options']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'value': value, 'option_id': optionId};
  }
}
