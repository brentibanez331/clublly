// This file is part of the Supabase Flutter package.
import 'package:supabase_flutter/supabase_flutter.dart';
import '/models/product.dart';


class ProductService {
  final Supabase _supabase = Supabase.instance;

  Future<List<Product>> getProducts() async {
    try {
      // First get all products
      final productsResponse = await _supabase.client
          .from('products')
          .select()
          .order('name');
      
      // Then get all product images
      final imagesResponse = await _supabase.client
          .from('productImages')
          .select()
          .eq('is_thumbnail', true);
      
      // Create a map of product IDs to their thumbnail images
      final imageMap = {
        for (var img in imagesResponse)
          img['product_id'] as int: img['image_path'] as String
      };
      
      // Create products with image paths
      return productsResponse.map<Product>((productJson) {
        final productId = productJson['id'] as int;
        return Product.fromMap({
          ...productJson,
          'image_path': imageMap[productId],
          'is_thumbnail': imageMap.containsKey(productId),
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}