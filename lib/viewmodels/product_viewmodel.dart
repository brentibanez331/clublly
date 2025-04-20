// viewmodels/product_view_model.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductViewModel extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> _organizationProducts = [];
  bool _isLoadingOrganizationProducts = false;
  int? _currentOrganizationId;

  List<Product> get products => _products;
  List<Product> get organizationProducts => _organizationProducts;
  bool get isLoading => _isLoading;
  bool get isLoadingOrganizationProducts => _isLoadingOrganizationProducts;
  String get errorMessage => _errorMessage;
  int? get currentOrganizationId => _currentOrganizationId;

  Future<void> addProduct(Product product) async {
    try {
      await supabase.from('products').upsert(product.toMap()).select();

      await fetchProductsByOrganization(product.organizationId);
    } catch (error) {
      log('Error adding product: ${error}');
    }
  }

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await supabase.from('products').select().order('name');

      _products =
          (response as List).map((item) => Product.fromMap(item)).toList();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch products: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsByOrganization(int organizationId) async {
    if (_currentOrganizationId == organizationId &&
        _organizationProducts.isNotEmpty) {
      return;
    }

    try {
      _isLoadingOrganizationProducts = true;
      _currentOrganizationId = organizationId;

      final response = await supabase
          .from('products')
          .select()
          .eq('organization_id', organizationId)
          .order('name', ascending: true);

      log(response.toString());

      _organizationProducts =
          (response as List).map((item) => Product.fromMap(item)).toList();
      _errorMessage = '';
    } catch (e) {
      _errorMessage =
          'Failed to fetch products for organization: ${e.toString()}';
    } finally {
      _isLoadingOrganizationProducts = false;
      notifyListeners();
    }
  }

  // Clear organization products (useful when switching organizations)
  void clearOrganizationProducts() {
    _organizationProducts = [];
    _currentOrganizationId = null;
    notifyListeners();
  }
}
