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
}
