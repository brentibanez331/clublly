// viewmodels/product_view_model.dart
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductViewModel extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Product> _products = [];
  Product? _productToAdd;

  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> _organizationProducts = [];
  bool _isLoadingOrganizationProducts = false;
  int? _currentOrganizationId;

  final ImagePicker _picker = ImagePicker();

  File? _thumbnail;
  List<XFile> _productImages = [];

  List<Product> get products => _products;
  Product? get productToAdd => _productToAdd;
  List<Product> get organizationProducts => _organizationProducts;
  bool get isLoading => _isLoading;
  bool get isLoadingOrganizationProducts => _isLoadingOrganizationProducts;
  String get errorMessage => _errorMessage;
  int? get currentOrganizationId => _currentOrganizationId;
  File? get thumbnail => _thumbnail;
  List<XFile> get productImages => _productImages;

  Future<void> pickThumbnail() async {
    log("THIS SHIT IS RUNNING");
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        _thumbnail = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<void> pickProductImages() async {
    try {
      log("${10 - _productImages.length}");

      _productImages.addAll(
        await _picker.pickMultiImage(limit: 10 - _productImages.length),
      );

      if (_productImages.length > 10) {
        _productImages = _productImages.sublist(
          0,
          _productImages.length < 10 ? _productImages.length : 10,
        );
      }

      notifyListeners();
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  void buildProduct(
    String name,
    String description,
    num basePrice,
    num baseStock,
    int organizationId,
    int categoryId,
  ) {
    _productToAdd = Product(
      name: name,
      description: description,
      basePrice: basePrice,
      baseStock: baseStock,
      organizationId: organizationId,
      categoryId: categoryId,
    );

    notifyListeners();
  }

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

  void clearThumbnail() {
    _thumbnail = null;
    notifyListeners();
  }

  void clearProductImages() {
    _productImages = [];
    notifyListeners();
  }

  void removeProductImage(int index) {
    if (index >= 0 && index < _productImages.length) {
      _productImages.removeAt(index);
      notifyListeners();
    }
  }
}
