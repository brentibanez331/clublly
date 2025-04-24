import 'package:flutter/material.dart';

class ProductVariantData {
  String? size;
  String? color;
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  ProductVariantData({this.size, this.color}) {
    priceController.text = '0';
    stockController.text = '0';
  }

  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'color': color,
      'price': priceController.text ?? 0,
      'stock_quantity': stockController.text ?? 0,
    };
  }
}
