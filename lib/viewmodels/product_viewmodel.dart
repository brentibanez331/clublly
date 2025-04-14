// viewmodels/product_view_model.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductViewModel extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabaseClient
          .from('products')
          .select()
          .order('name');

      _products = (response as List).map((item) => Product.fromMap(item)).toList();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch products: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}