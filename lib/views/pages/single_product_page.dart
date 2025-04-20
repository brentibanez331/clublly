import 'package:clublly/models/product.dart';
import 'package:flutter/material.dart';

class SingleProductPage extends StatefulWidget {
  final Product product;

  const SingleProductPage({super.key, required this.product});

  @override
  _SingleProductPageState createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [Text("Testing")]),
    );
  }
}
