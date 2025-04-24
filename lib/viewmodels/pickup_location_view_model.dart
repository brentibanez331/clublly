import 'dart:developer';

import 'package:clublly/models/pickup_location.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PickupLocationViewModel extends ChangeNotifier {
  List<PickupLocation> _pickupLocations = [];
  final supabase = Supabase.instance.client;

  List<PickupLocation> get pickupLocations => _pickupLocations;

  Future<void> addPickupLocation(PickupLocation pickupLocation) async {
    try {
      await supabase.from('pickupLocations').insert(pickupLocation.toMap());
    } catch (error) {
      log("Error adding pickup location: $error");
    }
  }
}
