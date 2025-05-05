import 'dart:developer';

import 'package:clublly/models/order.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderViewModel extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<Order> _organizationOrders = [];
  List<Order> _ordersByUser = [];

  bool _organizationOrdersLoading = false;
  bool _ordersByUserLoading = false;

  List<Order> get organizationOrders => _organizationOrders;
  List<Order> get ordersByUser => _ordersByUser;

  bool get organizationOrdersLoading => _organizationOrdersLoading;
  bool get ordersByUserLoading => _ordersByUserLoading;

  Future<void> addOrder(Order order, int cartId) async {
    try {
      final data = await supabase.from('orders').upsert(order.toMap()).select();
      log("$data");
      notifyListeners();
    } catch (error) {
      log("Failed to make order $error");
    }
  }

  Future<void> fetchOrdersByUser(String userId) async {
    try {
      _ordersByUserLoading = true;
      notifyListeners();

      final data = await supabase.from('orders').select('''
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
      ''');

      log("$data");
    } catch (error) {
      log("Failed to fetch your orders: $error");
    } finally {
      _ordersByUserLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrganizationOrders(int organizationId) async {
    try {
      // final data =await supabase.from('orders').select().
    } catch (error) {
      log("Failed to fetch your orders: $error");
    } finally {
      _organizationOrdersLoading = false;
      notifyListeners();
    }
  }
}
