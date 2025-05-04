import 'dart:developer';

import 'package:clublly/models/carts.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartViewModel extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<Carts> carts = [];
  bool _cartsByUserLoading = false;

  bool get cartsByUserLoading => _cartsByUserLoading;

  Future<void> addToCart(Carts cart) async {
    try {
      final data = await supabase.from('carts').upsert(cart.toMap()).select();
      await fetchCartsByUser(cart.userId);
      notifyListeners();
      log("$data");
    } catch (error) {
      log("Failed to add to cart ${error}");
    }
  }

  Future<void> fetchCartsByUser(String userId) async {
    try {
      _cartsByUserLoading = true;
      notifyListeners();

      final data = await supabase
          .from('carts')
          .select('''
            *,
            products(*, organizations(*), productImages!inner(id, image_path, is_thumbnail)),
            productVariants(
              id,
              product_id,
              price,
              stock_quantity,
              productVariantOptionValues(
                option_value_id,
                optionValues(
                  id,
                  option_id,
                  value,
                  options(type)
                )
              )
            )
          ''')
          .eq('user_id', userId);

      log("$data");

      carts = (data as List).map((cartMap) => Carts.fromMap(cartMap)).toList();
    } catch (error) {
      log("Failed to fetch your cart: $error");
    } finally {
      _cartsByUserLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCartItem(int cartId, String userId) async {
    try {
      await supabase.from('carts').delete().eq('id', cartId);

      await fetchCartsByUser(userId);
      notifyListeners();
    } catch (error) {
      log("Error deleting cart item: $error");
    }
  }
}
