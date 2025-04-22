import 'package:clublly/models/product.dart';
import 'package:flutter/material.dart';

class FirstProductPage extends StatefulWidget {
  final Product product;

  const FirstProductPage({super.key, required this.product});

  @override
  _FirstProductPageState createState() => _FirstProductPageState();
}

class _FirstProductPageState extends State<FirstProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [Text("test")]),
    );
  }
}
