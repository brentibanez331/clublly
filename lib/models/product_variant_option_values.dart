import 'dart:developer';

import 'package:clublly/models/option_value.dart';

class ProductVariantOptionValues {
  final OptionValue optionValues;
  final int optionValueId;

  ProductVariantOptionValues({
    required this.optionValues,
    required this.optionValueId,
  });

  factory ProductVariantOptionValues.fromMap(Map<String, dynamic> map) {
    return ProductVariantOptionValues(
      optionValues: OptionValue.fromMap(map['optionValues']),
      optionValueId: map['option_value_id'],
    );
  }
}
