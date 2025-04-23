import 'dart:developer';

import 'package:clublly/models/category.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryViewModel extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<Category> categories = [];

  Future<void> fetchCategories() async {
    try {
      final data = await supabase.from('categories').select();

      log(data.toString());
      categories =
          (data as List)
              .map((categoryMap) => Category.fromMap(categoryMap))
              .toList();
      notifyListeners();
    } catch (error) {
      log('Error fetching categories: ${error}');
    }
  }
}
