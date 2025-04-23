// viewmodels/product_view_model.dart
import 'dart:developer';
import 'dart:io';

import 'package:clublly/models/option_value.dart';
import 'package:clublly/models/product_variant_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

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

  List<String> _sizeValues = [];
  List<String> _colorValues = [];
  List<ProductVariantData> _variants = [];

  List<Product> get products => _products;
  Product? get productToAdd => _productToAdd;
  List<Product> get organizationProducts => _organizationProducts;
  bool get isLoading => _isLoading;
  bool get isLoadingOrganizationProducts => _isLoadingOrganizationProducts;
  String get errorMessage => _errorMessage;
  int? get currentOrganizationId => _currentOrganizationId;
  File? get thumbnail => _thumbnail;
  List<XFile> get productImages => _productImages;
  List<ProductVariantData> get variants => _variants;
  List<String> get sizeValues => _sizeValues;
  List<String> get colorValues => _colorValues;

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
    if (variants.isNotEmpty) {
      _productToAdd = Product(
        name: name,
        description: description,
        basePrice: 0,
        baseStock: 0,
        organizationId: organizationId,
        categoryId: categoryId,
      );
    } else {
      _productToAdd = Product(
        name: name,
        description: description,
        basePrice: basePrice,
        baseStock: baseStock,
        organizationId: organizationId,
        categoryId: categoryId,
      );
    }

    notifyListeners();
  }

  Future<void> addProduct() async {
    try {
      if (_productToAdd != null) {
        final data =
            await supabase
                .from('products')
                .upsert(_productToAdd!.toMap())
                .select();

        if (_thumbnail != null) {
          final uuid = Uuid().v4();
          final fileName = path.basename(_thumbnail!.path);
          final storageFilePath = '$uuid/$fileName';

          await supabase.storage
              .from('products')
              .upload(
                storageFilePath,
                _thumbnail!,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: false,
                ),
              );
        }

        await fetchProductsByOrganization(data[0]['organization_id']);
      }
    } catch (error) {
      log('Error adding product: ${error}');
    }
  }

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await supabase
          .from('products')
          .select('*, organizations(name)')
          .order('name');

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
          .select('*, organizations(name)')
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

  void regenerateVariants(bool enableSizes, bool enableColors) {
    // Save the current values if any
    Map<String, ProductVariantData> existingVariantData = {};
    for (var variant in variants) {
      String key = _getVariantKey(variant);
      existingVariantData[key] = variant;
    }

    // Generate all combinations
    List<ProductVariantData> newVariants = [];

    if (enableSizes &&
        enableColors &&
        sizeValues.isNotEmpty &&
        colorValues.isNotEmpty) {
      for (var size in sizeValues) {
        for (var color in colorValues) {
          String key = '${size}-${color}';

          if (existingVariantData.containsKey(key)) {
            newVariants.add(existingVariantData[key]!);
          } else {
            newVariants.add(ProductVariantData(size: size, color: color));
          }
        }
      }
    } else if (enableSizes && sizeValues.isNotEmpty) {
      for (var size in sizeValues) {
        String key = '$size-';
        if (existingVariantData.containsKey(key)) {
          newVariants.add(existingVariantData[key]!);
        } else {
          newVariants.add(ProductVariantData(size: size));
        }
      }
    } else if (enableColors && colorValues.isNotEmpty) {
      for (var color in colorValues) {
        String key = '-$color';
        if (existingVariantData.containsKey(key)) {
          newVariants.add(existingVariantData[key]!);
        } else {
          newVariants.add(ProductVariantData(color: color));
        }
      }
    }

    _variants = newVariants;
    notifyListeners();
  }

  String _getVariantKey(ProductVariantData variant) {
    return '${variant.size ?? ""}-${variant.color ?? ""}';
  }

  void addValueToSizes(String value) {
    _sizeValues.add(value);
    notifyListeners();
  }

  void removeValueFromSizes(int index) {
    _sizeValues.removeAt(index);
    notifyListeners();
  }

  void addValueToColors(String value) {
    _colorValues.add(value);
    notifyListeners();
  }

  void removeValueFromColors(int index) {
    _colorValues.removeAt(index);
    notifyListeners();
  }

  void clearSizeOrColor(String option) {
    if (option == 'Size') {
      _sizeValues.clear();
    } else {
      _colorValues.clear();
    }

    notifyListeners();
  }

  // void clearVariants() {
  //   _sizes = [];
  //   _colors = [];
  //   notifyListeners();
  // }
}
